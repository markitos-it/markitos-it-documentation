# Orquestación de CI/CD: Pipeline de Seguridad y Sincronización de Activos

En un ecosistema de desarrollo profesional, la automatización del ciclo de vida del software debe integrar dos pilares fundamentales: la sincronización segura de activos (golden assets) y la validación continua de la postura de seguridad (AppSec). Este pipeline, diseñado para Google Cloud Build, actúa como un guardián de calidad que garantiza que cada construcción cumpla con los estándares de seguridad antes de ser promovida.

El siguiente tutorial detalla la implementación de esta configuración, desglosando la gestión de secretos y la lógica de ejecución del flujo.

## Configuración del Pipeline (`cloudbuild.yaml`)

```yaml
steps:
  # Fase de Sincronización: Obtención de activos desde repositorios privados
  - name: 'gcr.io/cloud-builders/git'
    id: "Fetch Golden Assets"
    secretEnv: ['GITHUB_READONLY_REPOSITORIES_TOKEN']
    entrypoint: 'bash'
    args:
      - '-c'
      - |
        git clone --depth=1 https://markitos-it:$$GITHUB_READONLY_REPOSITORIES_TOKEN@github.com/markitos-it/markitos-it-project-golden-assets.git /workspace/golden-assets

  # Fase de Seguridad: Análisis estático y de dependencias con Snyk
  - name: "snyk/snyk:golang"
    id: "AppSec Security Suite"
    secretEnv: ['SNYK_TOKEN']
    env:
      - 'SEVERITY=high'
    script: |
      #!/bin/bash
      set -e
      
      echo "===> [Fase 1]: Escaneo de dependencias (SCA)..."
      snyk test --all-subprojects --severity-threshold=$SEVERITY
      
      echo "===> [Fase 2]: Escaneo de código estático (SAST)..."
      snyk code test --severity-threshold=$SEVERITY

# Definición de secretos gestionados en Google Secret Manager
availableSecrets:
  secretManager:
    - versionName: projects/$PROJECT_ID/secrets/SNYK_TOKEN/versions/latest
      env: "SNYK_TOKEN"
    - versionName: projects/$PROJECT_ID/secrets/GITHUB_READONLY_REPOSITORIES_TOKEN/versions/latest
      env: 'GITHUB_READONLY_REPOSITORIES_TOKEN'

options:
  logging: CLOUD_LOGGING_ONLY
  defaultLogsBucketBehavior: REGIONAL_USER_OWNED_BUCKET

```

## Documentación de Variables y Parámetros

Para asegurar la operatividad y mantenibilidad de esta infraestructura como código, es imperativo comprender la función de cada variable y configuración:

| Variable / Parámetro | Descripción |
| --- | --- |
| `GITHUB_READONLY_REPOSITORIES_TOKEN` | Token de acceso personal (PAT) con alcance de lectura únicamente, utilizado para autenticar el clonado del repositorio de activos. |
| `SNYK_TOKEN` | Credencial API para autenticar el agente de Snyk contra su plataforma de análisis de seguridad. |
| `$PROJECT_ID` | Variable reservada de Google Cloud que referencia al ID del proyecto actual donde se ejecuta el build. |
| `SEVERITY` | Umbral de severidad definido para los escaneos. Se establece en `high`, lo que significa que el pipeline fallará solo si se detectan vulnerabilidades de severidad alta o crítica. |
| `secretEnv` | Lista de variables que deben ser inyectadas desde el contexto de `availableSecrets` al entorno del contenedor específico durante su ejecución. |
| `availableSecrets` | Bloque global que vincula las versiones de los secretos almacenados en Secret Manager con las variables de entorno disponibles en todo el pipeline. |

## Análisis Técnico del Flujo de Trabajo

### 1. Gestión de Activos Seguros

El uso de `git clone --depth=1` no es casual; al limitar la profundidad del clonado a un solo commit, optimizamos el rendimiento del pipeline, descargando únicamente el estado actual del repositorio. La inyección del token a través de `secretEnv` garantiza que las credenciales nunca sean expuestas en los logs del sistema, cumpliendo con las mejores prácticas de **DevSecOps**.

### 2. Capas de Seguridad (AppSec)

El contenedor de Snyk ejecuta una evaluación en dos frentes:

* **SCA (Software Composition Analysis)**: Analiza el `go.mod` y los árboles de dependencias para identificar paquetes vulnerables. Al aplicar `--all-subprojects`, el escaneo es recursivo, cubriendo la totalidad de la estructura del proyecto.
* **SAST (Static Application Security Testing)**: Mediante `snyk code test`, el motor analiza la lógica del código fuente escrito en Go, detectando patrones inseguros, inyecciones o malas configuraciones, incluso antes de que el código sea compilado.

### 3. Consideraciones de Logging y Almacenamiento

La sección `options` configura un entorno limpio:

* `CLOUD_LOGGING_ONLY`: Desactiva la escritura de logs en archivos locales del builder, centralizando todo en Google Cloud Logging para auditorías rápidas.
* `REGIONAL_USER_OWNED_BUCKET`: Asegura que los metadatos y logs del build se almacenen en una región específica bajo propiedad del usuario, facilitando el cumplimiento de normativas de residencia de datos.

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