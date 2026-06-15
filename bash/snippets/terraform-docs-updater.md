# 🏗️ Automatización Documental: Terraform Docs Updater

La Infraestructura como Código (IaC) evoluciona rápidamente. Mantener el archivo `README.md` de cada módulo de Terraform sincronizado a mano con las variables, outputs y versiones de los providers es una tarea propensa a errores (y poco artesanal).

Para solventar esto, utilizamos `terraform-docs` combinado con un orquestador en Bash. Este script recorre dinámicamente nuestro espacio de trabajo, detecta dónde existen módulos válidos de Terraform y auto-inyecta o actualiza la documentación estructural de manera determinista.

---

## El Script: Auto-Forjado de Documentación IaC

Guarda este código como `update-tf-docs.sh` y dale permisos de ejecución (`chmod +x update-tf-docs.sh`). Puedes ejecutarlo manualmente o integrarlo como un *pre-commit hook* en Git.

```bash
#!/usr/bin/env bash
set -euo pipefail

# Configuración de la paleta de colores del Artesano
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
DIM='\033[2m'
NC='\033[0m'

echo -e "${CYAN}#:[.'.]:>- Iniciando el forjado de documentación de Terraform...${NC}\n"

# 1. Validación de dependencias
if ! command -v terraform-docs &> /dev/null; then
    echo -e "${RED}✖ Error: El binario 'terraform-docs' no se encuentra en el PATH.${NC}"
    echo -e "${YELLOW}Instálalo vía Go: ${NC}go install github.com/terraform-docs/terraform-docs@latest"
    exit 1
fi

# 2. Búsqueda determinista de módulos de Terraform
# Ignoramos los directorios '.terraform' cacheados para evitar ruido
MODULES=$(find . -type d -name ".terraform" -prune -o -type f -name "*.tf" -exec dirname {} \; | sort -u)

if [ -z "$MODULES" ]; then
    echo -e "${YELLOW}⚠ No se detectaron archivos .tf en la ruta actual.${NC}"
    exit 0
fi

# 3. Inyección de documentación
for MODULE in $MODULES; do
    echo -e "🚀 Analizando módulo en: ${YELLOW}${MODULE}${NC}..."
    
    # Ejecutamos terraform-docs en modo 'inject'. Esto requiere que el README.md
    # contenga las etiquetas <!-- BEGIN_TF_DOCS --> y <!-- END_TF_DOCS -->.
    if terraform-docs markdown table --output-file README.md --output-mode inject "$MODULE"; then
        echo -e "${GREEN}✅ Documentación sincronizada en ${MODULE}/README.md${NC}"
    else
        echo -e "${RED}✖ Fallo al generar documentación para ${MODULE}${NC}"
    fi
done

echo -e "\n${CYAN}#:[.'.]:>- El Camino del Artesano: Infraestructura documentada de forma inmutable.${NC}"
```

---

## Anatomía de la Automatización

### 1. El Flag `--output-mode inject`

En lugar de sobrescribir el archivo `README.md` completo, `terraform-docs` busca marcadores específicos dentro del documento. Esto nos permite tener una descripción artesanal escrita por humanos en la parte superior del archivo (filosofía, arquitectura, notas de uso), mientras que la herramienta actualiza automáticamente solo el bloque técnico interno entre las siguientes etiquetas:

```markdown
<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
```

### 2. Eficiencia en la Búsqueda (`find -prune`)

Los directorios locales `.terraform/` contienen miles de archivos `.tf` residuales descargados de los módulos oficiales de los proveedores (GCP, AWS). El flag `-prune` ordena al comando `find` que ignore completamente esas carpetas, ahorrando tiempo de procesamiento y evitando documentar código que no nos pertenece.

### 3. Integración en CI/CD

En una verdadera cultura DevSecOps, si un desarrollador modifica un archivo `variables.tf` y olvida ejecutar este script, la pipeline de Integración Continua (como GitHub Actions) debe detectar la discrepancia (`git diff --exit-code`) y fallar, garantizando que el código y la documentación en la rama `main` sean un reflejo exacto.

---

```bash
#:[.'.]:>- ===================================================================================
#:[.'.]:>- Marco Antonio - markitos devsecops kulture
#:[.'.]:>- The Way of the Artisan
#:[.'.]:>- markitos.es.info@gmail.com
#:[.'.]:>- 🌍 https://github.com/orgs/markitos-it/repositories
#:[.'.]:>- 🌍 https://github.com/orgs/markitos-public/repositories
#:[.'.]:>- 📺 https://www.youtube.com/@markitos_devsecops
#:[.'.]:>- ===================================================================================
```