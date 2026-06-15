#!/usr/bin/env bash
set -euo pipefail

# Configuración de la paleta de colores del Artesano
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
DIM='\033[2m'
NC='\033[0m'

echo -e "${CYAN}#:[.'.]:>- Starting Terraform documentation forging...${NC}\n"

# 1. Dependency validation
if ! command -v terraform-docs &> /dev/null; then
    echo -e "${RED}✖ Error: 'terraform-docs' binary not found in PATH.${NC}"
    echo -e "${YELLOW}Install it via Go: ${NC}go install github.com/terraform-docs/terraform-docs@latest"
    exit 1
fi

# 2. Deterministic search for Terraform modules
# We ignore cached '.terraform' directories to avoid noise
MODULES=$(find . -type d -name ".terraform" -prune -o -type f -name "*.tf" -exec dirname {} \; | sort -u)

if [ -z "$MODULES" ]; then
    echo -e "${YELLOW}⚠ No .tf files detected in the current path.${NC}"
    exit 0
fi

# 3. Documentation injection
for MODULE in $MODULES; do
    echo -e "🚀 Analyzing module in: ${YELLOW}${MODULE}${NC}..."
    
    # We run terraform-docs in 'inject' mode. This requires README.md
    # to contain the <!-- BEGIN_TF_DOCS --> and <!-- END_TF_DOCS --> tags.
    if terraform-docs markdown table --output-file README.md --output-mode inject "$MODULE"; then
        echo -e "${GREEN}✅ Documentation synchronized in ${MODULE}/README.md${NC}"
    else
        echo -e "${RED}✖ Failed to generate documentation for ${MODULE}${NC}"
    fi
done

echo -e "\n${CYAN}#:[.'.]:>- The Artisan's Way: Infrastructure documented immutably.${NC}"
