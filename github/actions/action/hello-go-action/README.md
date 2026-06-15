# Arquitectura de Custom Actions en Go: Modularidad y Eficiencia

La creación de *GitHub Actions* nativas utilizando Go transforma la automatización de infraestructura en código de ingeniería robusto. A diferencia de los scripts de shell, esta arquitectura permite aprovechar el tipado estático, la gestión de dependencias y la concurrencia de Go, elevando la calidad de los procesos de CI/CD a estándares de producción.

A continuación, se detalla la estructura y configuración necesaria para implementar una *Composite Action* con lógica en Go.

## 1. Núcleo Lógico (`action.go`)

Este componente encapsula la lógica de negocio. Al aceptar argumentos a través de `os.Args`, permitimos que la acción sea parametrizada desde el flujo de trabajo principal.

```go
package main

import (
    "fmt"
    "os"
)

func main() {
    nombre := "Markitos"
    if len(os.Args) > 1 {
        nombre = os.Args[1]
    }
    fmt.Printf("🚀 ¡Hola, %s! Este saludo viene desde un programa en Go compilado al vuelo.\n", nombre)
}

```

## 2. Definición de la Interfaz (`action.yaml`)

Este archivo actúa como el contrato de la acción. Define los insumos (*inputs*) y el entorno de ejecución. Es crucial notar el uso de `$GITHUB_ACTION_PATH`, que garantiza que el código de Go sea localizado correctamente independientemente del directorio de trabajo del *runner*.

```yaml
name: 'Hola Go Action'
description: 'Ejecuta un programa en Go'

inputs:
  nombre:
    description: 'Nombre a saludar'
    required: false
    default: 'Markitos'

runs:
  using: "composite"
  steps:
    - name: Ejecutar programa Go
      shell: bash
      run: |
        go run "$GITHUB_ACTION_PATH/action.go" "${{ inputs.nombre }}"

```

## 3. Orquestador de Flujo (`hello-workflow.yaml`)

El flujo de trabajo consume la acción definida. La clave reside en la referencia local (`./.github/actions/...`), que permite integrar módulos personalizados sin necesidad de publicar la acción en repositorios externos, ideal para lógica privada de la organización.

```yaml
name: Ejemplo de Uso
on: [push]

jobs:
  saludar:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout del repositorio
        uses: actions/checkout@v5

      - name: Instalar Go
        uses: actions/setup-go@v6
        with:
          go-version: '1.26'
          cache: false

      - name: Ejecutar saludo personalizado
        uses: ./.github/actions/hello-go-action
        with:
          nombre: "Markitos"

```

## Consideraciones de Grado Industrial

Para escalar esta implementación hacia entornos productivos de alta exigencia, se deben considerar los siguientes principios:

1. **Optimización del Tiempo de Ejecución**: Actualmente, el comando `go run` compila el programa en cada ejecución. En flujos de CI críticos, este *overhead* es innecesario. Se recomienda pre-compilar el binario dentro del paso de ejecución o en una etapa previa, utilizando `go build -o action_bin action.go` y ejecutando `./action_bin`.
2. **Estructura de Directorios**: Para que GitHub Actions reconozca la acción, la estructura de archivos debe ser estricta. El `action.yaml` debe estar directamente en la raíz de la carpeta definida en el `uses` del flujo de trabajo (`.github/actions/hello-go-action/action.yaml`).
3. **Manejo de Errores**: El código Go debe implementar salidas de error explícitas (`os.Exit(1)`) en caso de fallo, para que el *runner* de GitHub detecte correctamente la falla de la acción y detenga el pipeline.

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