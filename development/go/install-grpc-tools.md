# Microservicios con gRPC

A continuación se presenta el orquestador de instalación, estructurado para dotar a tu estación de trabajo de las capacidades de compilación requeridas.

## Código del Orquestador de Instalación

```bash
#!/bin/bash
echo
echo "#=============================================="
echo "#  __  __  ____  _  __"
echo "# |  \/  |  _ \| |/ /"
echo "# | \  / | | | | ' / "
echo "# | |\/| | | | |  <  "
echo "# | |  | | |_| | . \ "
echo "# |_|  |_|____/|_|\\_\\"
echo "#"
echo "#  Creator: Marco Antonio - markitos"
echo "#=============================================="
echo "#  Markitos DevSecOps Kulture"
echo "#=============================================="
echo
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/../"
set -euo pipefail
IFS=$'\n\t'

#:[.'.]:> -----------------------------------------------------
#:[.'.]:> Definir funciones de logging
#:[.'.]:> -----------------------------------------------------
function log_info() {
    echo -e "\033[1;34m[INFO]\033[0m $*"
}

function log_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $*" >&2
}

function log_success() {
    echo -e "\033[1;32m[SUCCESS]\033[0m $*"
}
#:[.'.]:> -----------------------------------------------------

#:[.'.]:> -----------------------------------------------------
#:[.'.]:> Mostrar lo que hará el script
#:[.'.]:> -----------------------------------------------------
echo -e "\033[1;36mThis script will install the following tools into ~/.local/bin:\033[0m"
echo -e "  - \033[1;33mprotoc\033[0m (Protocol Buffers Compiler)"
echo -e "  - \033[1;33mGo plugins for gRPC\033[0m"
echo
echo -e "\033[1;36mSummary of actions:\033[0m"
echo -e "  1. Download and install protoc."
echo -e "  2. Install Go plugins for gRPC."
echo -e "  3. Update PATH in ~/.bashrc."
echo
echo -e "\033[1;33mPress CTRL+C to cancel or ENTER to continue...\033[0m"
read -r
#:[.'.]:> -----------------------------------------------------

#:[.'.]:> -----------------------------------------------------
#:[.'.]:> Crear directorio ~/.local/bin si no existe
#:[.'.]:> -----------------------------------------------------
mkdir -p ~/.local/bin
#:[.'.]:> -----------------------------------------------------

#:[.'.]:> -----------------------------------------------------
#:[.'.]:> OPCION 1 - Instalar protoc con apt (RECOMENDADO)
#:[.'.]:> -----------------------------------------------------
sudo apt install protobuf-compiler libprotobuf-dev
#:[.'.]:> -----------------------------------------------------

#:[.'.]:> -----------------------------------------------------
#:[.'.]:> OPCION 2 Instalar manualmente (NO RECOMENDADO)
#:[.'.]:> -----------------------------------------------------
# PROTOC_VERSION=30.1
# log_info "Descargando e instalando protoc (versión ${PROTOC_VERSION})..."
# cd /tmp
# curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip
# sudo apt install unzip -y
# unzip protoc-${PROTOC_VERSION}-linux-x86_64.zip -d protoc
# mv protoc/bin/protoc ~/.local/bin/protoc
# mv protoc/include/* ~/.local/include/
# rm -rf protoc protoc-${PROTOC_VERSION}-linux-x86_64.zip
# log_success "protoc instalado correctamente. Versión: $(~/.local/bin/protoc --version)"
#:[.'.]:> -----------------------------------------------------


#:[.'.]:> -----------------------------------------------------
#:[.'.]:> Instalar plugins de Go para gRPC
#:[.'.]:> -----------------------------------------------------
log_info "Installing Go plugins for gRPC..."
GOBIN=~/.local/bin go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
GOBIN=~/.local/bin go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
log_success "Go plugins for gRPC installed successfully."
#:[.'.]:> -----------------------------------------------------


#:[.'.]:> -----------------------------------------------------
#:[.'.]:> Actualizar PATH en ~/.bashrc
#:[.'.]:> -----------------------------------------------------
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    log_info "Updating PATH in ~/.bashrc..."
    echo 'export PATH=${PATH}:${HOME}/.local/bin' >> ~/.bashrc
    source ~/.bashrc
    log_success "PATH updated successfully."
else
    log_info "PATH already includes ~/.local/bin."
fi
#:[.'.]:> -----------------------------------------------------

#:[.'.]:> -----------------------------------------------------
#:[.'.]:> Verificar instalación (SOLO INSTALACION OPCION 1)
#:[.'.]:> -----------------------------------------------------
log_info "Verifying installed tools..."
PROTOC_VERSION_INSTALLED=$(~/.local/bin/protoc --version 2>/dev/null || echo "Not installed")
#:[.'.]:> -----------------------------------------------------

#:[.'.]:> -----------------------------------------------------
#:[.'.]:> Verificar instalación el resto de herramientas (INSTALACION OPCION 1 Y OPCION 2)
#:[.'.]:> -----------------------------------------------------
PROTOC_GEN_GO_VERSION=$(~/.local/bin/protoc-gen-go --version 2>/dev/null || echo "Not installed")
PROTOC_GEN_GO_GRPC_VERSION=$(~/.local/bin/protoc-gen-go-grpc --version 2>/dev/null || echo "Not installed")
#:[.'.]:> -----------------------------------------------------

#:[.'.]:> -----------------------------------------------------
#:[.'.]:> Mostrar informe final
#:[.'.]:> -----------------------------------------------------
echo
echo -e "\033[1;36mSummary:\033[0m"
if [[ "$PROTOC_VERSION_INSTALLED" != "Not installed" ]]; then
    log_success "protoc installed. Version: $PROTOC_VERSION_INSTALLED"
else
    log_error "protoc was not installed correctly."
fi

if [[ "$PROTOC_GEN_GO_VERSION" != "Not installed" ]]; then
    log_success "protoc-gen-go installed. Version: $PROTOC_GEN_GO_VERSION"
else
    log_error "protoc-gen-go was not installed correctly."
fi

if [[ "$PROTOC_GEN_GO_GRPC_VERSION" != "Not installed" ]]; then
    log_success "protoc-gen-go-grpc installed. Version: $PROTOC_GEN_GO_GRPC_VERSION"
else
    log_error "protoc-gen-go-grpc was not installed correctly."
fi

echo
log_success "Installation complete. Ready to use."
#:[.'.]:> -----------------------------------------------------

```

## Análisis Arquitectónico del Entorno de Compilación

La adopción de arquitecturas orientadas a servicios exige abandonar los formatos de intercambio ineficientes en favor de esquemas fuertemente tipados. Desglosaremos los componentes que este script ensambla para lograr esa robustez en el desarrollo backend.

### El Paradigma de Protocol Buffers

El comando `sudo apt install protobuf-compiler` introduce en el sistema el binario base `protoc`. A diferencia de JSON o XML, que transmiten datos en texto plano añadiendo una enorme sobrecarga de parseo y tamaño de payload, Protocol Buffers serializa los datos en formato binario. El compilador `protoc` es el motor neutral en cuanto a lenguaje que lee los archivos `.proto`, donde se definen las estructuras de datos (mensajes), y comprende la topología abstracta de la información antes de delegar la generación de código específico a los plugins.

### Generación de Código y Stubs en Go

La ejecución de los comandos `go install` para los plugins es el puente entre la definición abstracta y la implementación real en código fuente.

* **`protoc-gen-go`**: Este plugin toma el árbol de sintaxis abstracta generado por `protoc` y produce archivos `.pb.go`. Estos archivos contienen las estructuras nativas de Go que representan los mensajes, junto con métodos de serialización y deserialización altamente optimizados. Esto garantiza que si un servicio emite un entero de 64 bits, el servicio receptor lo interprete exactamente igual en memoria, evitando los clásicos errores de conversión de tipos.
* **`protoc-gen-go-grpc`**: Mientras que el plugin anterior maneja los datos, este genera la capa de transporte. Produce los archivos `_grpc.pb.go`, los cuales contienen las interfaces de cliente y servidor necesarias para establecer llamadas a procedimientos remotos (RPC) sobre HTTP/2. Esto incluye la gestión intrínseca de multiplexación, flujos de datos bidireccionales y plazos de ejecución predefinidos en la lógica del marco gRPC.

### Aislamiento de Binarios Locales

Una decisión de diseño notable en el script es la alteración de la variable de entorno mediante `GOBIN=~/.local/bin go install ...`. Por defecto, Go instalaría estos ejecutables en la ruta configurada en `$GOPATH/bin`. Al forzar la instalación en `~/.local/bin`, se consigue un aislamiento táctico. Los binarios del sistema permanecen intactos, mientras que las herramientas de usuario necesarias para el flujo de trabajo de desarrollo se agrupan en una ubicación controlada y estandarizada en sistemas UNIX. La posterior validación y adición de esta ruta al `PATH` del archivo `~/.bashrc` asegura que los comandos estén disponibles globalmente para cualquier sesión de terminal interactiva o tubería de ejecución.

## Guía de Despliegue Rápido

Para integrar estas capacidades en una máquina de desarrollo limpia:

1. Crea el archivo `grpc_setup.sh` e inserta el código proporcionado.
2. Otorga los permisos de ejecución necesarios con `chmod +x grpc_setup.sh`.
3. Ejecuta el orquestador mediante `./grpc_setup.sh` y sigue las instrucciones en pantalla para confirmar la instalación.

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