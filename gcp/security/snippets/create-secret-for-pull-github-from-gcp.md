# Secretos y Acceso Seguro en Google Cloud

```bash
#!/usr/bin/env bash
set -euo pipefail

# Validación de variables de entorno esenciales
if [[ -z "${SERVICE_ACCOUNT_EMAIL:-}" ]]; then
    echo "Error: La variable de entorno SERVICE_ACCOUNT_EMAIL no está definida o está vacía." >&2
    exit 1
fi

if [[ -z "${SECRET_NAME:-}" ]]; then
    echo "Error: La variable de entorno SECRET_NAME no está definida o está vacía." >&2
    exit 1
fi

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
    echo "Error: La variable de entorno GITHUB_TOKEN no está definida o está vacía." >&2
    exit 1
fi

# Habilitar el servicio de Secret Manager en el proyecto activo
gcloud services enable secretmanager.googleapis.com

# Crear el secreto e inyectar el valor de forma segura desde la entrada estándar
echo -n "${GITHUB_TOKEN}" | gcloud secrets create "$SECRET_NAME" --data-file=-

# Restringir el acceso otorgando el rol de lector únicamente a la cuenta de servicio
gcloud secrets add-iam-policy-binding "$SECRET_NAME" \
    --member="serviceAccount:${SERVICE_ACCOUNT_EMAIL}" \
    --role="roles/secretmanager.secretAccessor"

```

## Análisis Detallado de los Componentes

Para comprender el impacto de este script en una arquitectura DevSecOps robusta, es necesario desglosar los conceptos avanzados que operan en cada línea de ejecución.

### El Paradigma Fail Fast

La declaración inicial `set -euo pipefail` cambia por completo el comportamiento por defecto de Bash para alinearlo con los estándares de desarrollo de software profesional:

* **`-e` (errexit)**: Interrumpe inmediatamente la ejecución si cualquier comando devuelve un código de salida no nulo. Esto evita el "efecto dominó", donde un fallo inicial pasa desapercibido y corrompe los pasos subsiguientes.
* **`-u` (nounset)**: Trata las variables no definidas como un error grave. En scripts de infraestructura, una variable vacía accidental podría provocar la eliminación de recursos incorrectos o configuraciones corruptas.
* **`-o pipefail`**: Garantiza que si un comando falla dentro de una tubería (pipe), todo el pipeline devuelva el código de error del comando fallido, en lugar de enmascararlo con el éxito del último comando ejecutado.

Las estructuras condicionales `[[ -z "${VARIABLE:-}" ]]` complementan este enfoque defensivo. Al evaluar de forma segura si las cadenas están vacías antes de interactuar con las APIs de Google Cloud, se mitigan llamadas fallidas y se proporciona retroalimentación inmediata al operador o al pipeline de CI/CD.

### Gestión Automatizada de Secretos

El uso de Secret Manager centraliza la configuración sensible, eliminando las malas prácticas de almacenar tokens en texto plano dentro de repositorios o sistemas de archivos locales.

Un detalle crítico en la construcción de este comando es la combinación de `echo -n` junto con `--data-file=-`. El flag `-n` impide que se añada un carácter de salto de línea (`\n`) al final del token de GitHub. Si no se manejara de este modo, el sistema externo que consuma el secreto fallaría al autenticar debido a ese espacio en blanco invisible. Al pasar la información a través de la entrada estándar (`-`), el secreto se transmite directamente en memoria, evitando escribir datos sensibles en archivos temporales del disco duro que puedan ser expuestos.

### Principio de Mínimo Privilegio con IAM

La última sección del script ejecuta un enlace de políticas de IAM (`add-iam-policy-binding`). En lugar de otorgar permisos globales a nivel de proyecto, la política se aplica de forma granular y exclusiva sobre el recurso recién creado.

El rol `roles/secretmanager.secretAccessor` es el permiso más restrictivo diseñado para el consumo de credenciales. Permite que la cuenta de servicio especificada lea el valor del secreto, pero le impide por completo modificarlo, destruirlo o listar otros secretos existentes dentro de la organización de Google Cloud.

## Preparación y Despliegue

Para poner en marcha esta automatización en un entorno operativo, se deben exportar las variables requeridas antes de invocar el binario:

```bash
# Configurar las variables del entorno operativo
export SERVICE_ACCOUNT_EMAIL="my-app-sa@my-gcp-project.iam.gserviceaccount.com"
export SECRET_NAME="github-integration-token"
export GITHUB_TOKEN="ghp_SecretTokenGeneradoEnGithubAsociadoAlServicio"

# Asignar permisos y ejecutar el proceso
chmod +x secret_for_github.sh
./secret_for_github.sh
```

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