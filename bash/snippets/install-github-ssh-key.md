# Forjado Automatizado de Identidades Criptográficas (SSH)

En la filosofía DevSecOps, el acceso a los servidores y repositorios no debe depender de contraseñas estáticas vulnerables a ataques de diccionario o fuerza bruta, sino de pares de claves criptográficas asimétricas. Al igual que un maestro cerrajero forja una llave maestra única y de alta precisión para asegurar un conducto crítico, este script estandariza y automatiza la creación de credenciales SSH.

Este automatismo garantiza que cada integración, servicio o desarrollador disponga de una identidad robusta de forma inmediata, eliminando el error humano en la configuración y exponiendo directamente la clave pública lista para ser distribuida.

## Código del Generador de Claves

```bash
#!/bin/bash

# Validación estricta de argumentos de entrada
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <solo-letras-minus-key-name> <email>"
    exit 1
fi

KEY_NAME=$1
EMAIL=$2
SSH_DIR="$HOME/.ssh"
KEY_FILE="$SSH_DIR/$KEY_NAME"

# Garantizar la existencia del directorio de claves
mkdir -p "$SSH_DIR"

# Generación del par de claves criptográficas
ssh-keygen -t rsa -b 4096 -C "$EMAIL" -f "$KEY_FILE" -N ""

# Exposición de la clave pública para su distribución
echo "Clave pública generada:"
cat "${KEY_FILE}.pub"

```

## Anatomía de la Generación Criptográfica

Para comprender el valor de este script en un flujo de trabajo profesional, es necesario diseccionar los parámetros técnicos que garantizan tanto la seguridad como la automatización del proceso:

### 1. Control de Ejecución Determinista

La estructura `if [ "$#" -ne 2 ]` actúa como un guardián (gatekeeper). Un script de infraestructura nunca debe asumir valores por defecto para elementos de seguridad críticos. Si el operador o la tubería de CI/CD no proporciona exactamente el nombre de la clave y el correo electrónico (usado para auditoría), el script aborta inmediatamente con un código de error (`exit 1`), documentando el uso correcto en la salida estándar.

### 2. Idempotencia del Entorno

El uso de `mkdir -p "$HOME/.ssh"` asegura que el directorio contenedor exista. La bandera `-p` (parents) hace que el comando sea idempotente: si el directorio ya existe, no devuelve error y continúa silenciosamente; si no existe, lo crea con la estructura de árbol necesaria.

### 3. Criptografía Robusta (`ssh-keygen`)

El núcleo del script reside en la invocación paramétrica de la herramienta de generación de claves, configurada para cumplir con estándares empresariales:

* **`-t rsa -b 4096`**: Especifica el algoritmo RSA con una longitud de bloque de 4096 bits. Aunque algoritmos como Ed25519 son más modernos y rápidos, RSA 4096 sigue siendo el estándar de oro para máxima compatibilidad con sistemas heredados corporativos, hardware antiguo y servicios en la nube, ofreciendo una resistencia criptográfica invulnerable a los ataques actuales.
* **`-C "$EMAIL"`**: Añade un comentario (metadato) al final de la clave pública. En un entorno de microservicios con cientos de claves autorizadas en un archivo `authorized_keys`, esta firma es vital para la trazabilidad y la auditoría visual de quién o qué servicio posee el acceso.
* **`-f "$KEY_FILE"`**: Fuerza la ruta de salida del archivo, evitando la interacción interactiva que pregunta al usuario dónde guardar la clave (por defecto `id_rsa`).
* **`-N ""` (Zero-Friction Automation)**: Establece una *passphrase* (contraseña) vacía. En entornos de integración continua (pipelines de GitHub Actions, GitLab CI) o para cuentas de servicio máquina-a-máquina (M2M), los procesos automatizados no pueden introducir contraseñas interactivamente. Esto permite generar la clave al vuelo para que sea inyectada temporalmente en el agente.

## Guía de Uso Rápido

Para forjar una nueva identidad, simplemente ejecuta el script pasando el identificador de la clave (en minúsculas por convención de nomenclatura) y el correo de trazabilidad:

```bash
chmod +x ssh_forge.sh
./ssh_forge.sh github-deploy-key bot-deploy@midominio.com

```

El sistema generará silenciosamente el archivo privado (`~/.ssh/github-deploy-key`) y mostrará directamente por pantalla el contenido de la clave pública (`~/.ssh/github-deploy-key.pub`) para que puedas copiarla y pegarla inmediatamente en GitHub, GitLab o el proveedor de infraestructura destino.

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