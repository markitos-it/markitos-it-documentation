# Github Action con uso de Makefile docker postgres y appsec

En un entorno de ingeniería de software de alta precisión, la integración continua es similar a un laboratorio de calibración de instrumentos científicos. Antes de que cualquier componente pueda ser certificado para producción, debe pasar por una serie de pruebas estandarizadas: limpieza, entorno de ejecución, validación de estado y auditoría de seguridad. Este pipeline de GitHub Actions no solo compila el código, sino que garantiza que cada pieza del sistema (la base de datos, el servicio y la lógica de seguridad) opere en total armonía antes de proceder.

## Orquestación del Pipeline

La siguiente configuración define un flujo de trabajo robusto que valida la infraestructura antes de ejecutar cualquier suite de pruebas.

```yaml
name: Go CI & Security Checks

on:
  push:
    branches: [ main, master, develop ]
  pull_request:
    branches: [ main, master, develop ]

jobs:
  test-and-security:
    name: Run Tests and AppSec
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Set up Go
        id: setup-go
        uses: actions/setup-go@v5
        with:
          go-version: '1.26.4'
          cache: true

      - name: Start Postgres Database
        id: db-start
        run: |
          make db-start

      - name: Wait for Postgres to be healthy
        id: db-healthy
        run: |
          echo "⏳ Waiting for container to report HEALTHY status..."
          until [ "$(docker inspect --format='{{json .State.Health.Status}}' goevents-postgres)" == "\"healthy\"" ]; do
            sleep 1
          done
          echo "✅ Postgres is 100% operational!"

      - name: Create Database
        id: db-create
        env:
          PGHOST: 127.0.0.1
          PGUSER: admin
          PGPASSWORD: admin
        run: |
          docker exec -i goevents-postgres psql -U admin -d postgres -c "DROP DATABASE IF EXISTS goevents;"
          make db-create

      - name: Tidy Go Modules
        id: tidy
        run: |
          make tidy

      - name: Start API Server & Wait for Port 30000
        id: api-start
        run: |
          make start > api_server.log 2>&1 &
          echo "⏳ Waiting dynamically for the API to respond on port 30000..."
          FORKS=0
          until nc -z 127.0.0.1 30000 || [ $FORKS -eq 60 ]; do
            sleep 1
            FORKS=$((FORKS + 1))
          done
          if nc -z 127.0.0.1 30000; then
            echo "✅ API successfully started and tables are ready!"
          else
            echo "❌ ERROR: API failed to start on port 30000 in time."
            cat api_server.log
            exit 1
          fi

      - name: Run Unit Tests
        id: unit-tests
        run: |
          make test

      - name: Install Security & Linting Tools
        id: tools-install
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          echo "📦 Installing Snyk via NPM..."
          npm install -g snyk
          
          echo "📦 Installing Gitleaks..."
          GITLEAKS_VERSION=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/repos/gitleaks/gitleaks/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/v//')
          curl -sSfL "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz" | tar -xz
          sudo cp gitleaks /usr/local/bin/

          echo "📦 Installing GolangCI-Lint..."
          GOLANGCI_VERSION=$(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/repos/golangci/golangci-lint/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/v//')
          curl -sSfL "https://github.com/golangci/golangci-lint/releases/download/v${GOLANGCI_VERSION}/golangci-lint-${GOLANGCI_VERSION}_linux_amd64.tar.gz" | tar -xz
          sudo cp "golangci-lint-${GOLANGCI_VERSION}-linux-amd64/golangci-lint" /usr/local/bin/
          
          rm -rf gitleaks golangci-lint-${GOLANGCI_VERSION}-linux-amd64
          rm -rf LICENSE README.md

      - name: Run Application Security Tests
        id: appsec
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        run: |
          make appsec-test
          EXIT_CODE=$?
          if [ $EXIT_CODE -ne 0 ]; then
            echo "❌ AppSec suite detected security vulnerabilities."
            exit $EXIT_CODE
          fi

      - name: Generate Beautiful Job Summary
        if: always()
        run: |
          status_to_emoji() {
            if [ "$1" == "success" ]; then
              echo "✅"
            elif [ "$1" == "failure" ]; then
              echo "❌"
            elif [ "$1" == "cancelled" ]; then
              echo "🛑"
            else
              echo "⏭️"
            fi
          }
          
          {
            echo "## 🚀 Goevents DevSecOps - Execution Report"
            echo "---"
            echo "### 📊 CI Infrastructure Summary"
            echo "| Component | Configuration | Result |"
            echo "| :--- | :--- | :---: |"
            echo "| 🦫 **Core Environment** | Go v1.26.4 | $(status_to_emoji '${{ steps.setup-go.outcome }}') |"
            echo "| 🐘 **Database Service** | Postgres 17 | $(status_to_emoji '${{ steps.db-healthy.outcome }}') |"
            echo "| ⚡ **API Readiness** | Port 30000 Active | $(status_to_emoji '${{ steps.api-start.outcome }}') |"
            echo "| 🛡️ **AppSec Suite** | Security Audit | $(status_to_emoji '${{ steps.appsec.outcome }}') |"
          } >> $GITHUB_STEP_SUMMARY

```

## Análisis Técnico de los Componentes

Para comprender la resiliencia de este pipeline, debemos analizar cómo maneja la concurrencia y la actualización de herramientas.

### Gestión Dinámica de Dependencias

Un error común en las tuberías de CI es el uso de versiones estáticas de herramientas de seguridad. Este script emplea un enfoque dinámico: mediante llamadas a la API de GitHub (`https://api.github.com/repos/.../releases/latest`), el pipeline recupera la versión más reciente de `Gitleaks` y `GolangCI-Lint` en cada ejecución. Esto asegura que los escaneos de seguridad siempre utilicen las últimas firmas de vulnerabilidades, evitando la degradación de la protección contra nuevas amenazas (`Zero-Day`).

### El Protocolo de Espera Activa

En la sección de inicio de API (`api-start`), utilizamos `netcat` (`nc`) con un bucle `until` y un contador de reintentos (`FORKS`). Esto es superior a un simple `sleep` estático. Si el servidor API arranca en 2 segundos, el pipeline continúa instantáneamente, reduciendo el tiempo total de ejecución. Si tarda más, el pipeline espera de forma controlada hasta un límite de 60 segundos antes de reportar un fallo, previniendo falsos negativos por latencia del entorno virtualizado.

### Estrategia de Auditoría y Resumen

El uso de `$GITHUB_STEP_SUMMARY` transforma la terminal opaca de GitHub Actions en un informe ejecutivo visual. La función `status_to_emoji` traduce los resultados de `outcome` de cada paso (`success`, `failure`, etc.) en indicadores visuales. Esto permite a cualquier miembro del equipo, técnico o de gestión, identificar qué componente falló (si la base de datos no arrancó o si hubo una falla en la suite de seguridad) sin necesidad de revisar miles de líneas de log, promoviendo una cultura de transparencia y rápida corrección (MTTR - Mean Time To Repair).

### Principio de Fail Fast en Seguridad

El bloque `appsec` no solo ejecuta la suite de seguridad, sino que captura el código de salida real (`EXIT_CODE=$?`). Si la herramienta detecta vulnerabilidades, el pipeline se detiene inmediatamente con un error explícito. Esto es vital en DevSecOps: impedir que código inseguro progrese por el pipeline, protegiendo la integridad del artefacto final antes de que este llegue a entornos de staging o producción.

---

```markdown
#:[.'.]:>- ===================================================================================
#:[.'.]:>- Marco Antonio - markitos devsecops kulture
#:[.'.]:>- The Way of the Artisan
#:[.'.]:>- markitos.es.info@gmail.com
#:[.'.]:>- 🌍 https://github.com/orgs/markitos-it/repositories
#:[.'.]:>- 🌍 https://github.com/orgs/markitos-public/repositories
#:[.'.]:>- 📺 https://www.youtube.com/@markitos_devsecops
#:[.'.]:>- ===================================================================================
```