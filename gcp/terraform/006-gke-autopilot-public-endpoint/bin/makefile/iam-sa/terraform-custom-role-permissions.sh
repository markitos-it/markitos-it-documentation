#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"


if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <ROLE_ID> <SERVICE_ACCOUNT_NAME> <PROJECT_ID>"
    exit 1
fi

ROLE_ID=$1
SERVICE_ACCOUNT_NAME=$2
PROJECT_ID=$3
KEY_PATH="../../.nogit/${SERVICE_ACCOUNT_NAME}-${PROJECT_ID}.json"

echo "==============================================="
echo "ROLE_ID:              ${ROLE_ID}"
echo "SERVICE_ACCOUNT_NAME: ${SERVICE_ACCOUNT_NAME}"
echo "PROJECT_ID:           ${PROJECT_ID}"
echo "KEY_PATH:             ${KEY_PATH}"
echo "==============================================="


#:------------------------------------------------------------
echo
echo "Checking/Creating service account: ${SERVICE_ACCOUNT_NAME}"
sleep 0.5
if ! gcloud iam service-accounts describe "${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" --project="${PROJECT_ID}" >/dev/null 2>&1; then
  gcloud iam service-accounts create "$SERVICE_ACCOUNT_NAME" \
    --project="${PROJECT_ID}" \
    --display-name="Service Account for Terraform"
  echo "Service account created."
else
  echo "Service account already exists."
fi
#:------------------------------------------------------------


#:------------------------------------------------------------
echo "enabling services for project: ${PROJECT_ID}"
sleep 0.5
gcloud services enable \
  --project=${PROJECT_ID} \
  compute.googleapis.com \
  container.googleapis.com \
  iam.googleapis.com \
  storage.googleapis.com
echo "services enabled"
sleep 2
#:------------------------------------------------------------


#:------------------------------------------------------------
echo "creating role: ${ROLE_ID}"
PERMISSIONS=$(grep -v -e '^#' -e '^$' ./terraform-custom-role-permissions.list | paste -sd, -)

if ! gcloud iam roles describe "$ROLE_ID" --project="${PROJECT_ID}" >/dev/null 2>&1; then
  echo "Role does not exist. Creating..."
  gcloud iam roles create "$ROLE_ID" \
    --project="${PROJECT_ID}" \
    --title="Custom Role for Terraform" \
    --description="Custom role for Terraform with minimum required permissions" \
    --permissions="$PERMISSIONS" \
    --stage="GA"
else
  echo "Role exists. Updating permissions..."
  gcloud iam roles update "$ROLE_ID" --project="${PROJECT_ID}" --permissions="$PERMISSIONS"
fi
echo "Role is up to date."
#:------------------------------------------------------------


#:------------------------------------------------------------
echo "binding service account: ${SERVICE_ACCOUNT_NAME} to role: ${ROLE_ID}"
sleep 0.5
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="projects/${PROJECT_ID}/roles/${ROLE_ID}"
echo "service account bound to role"
#:------------------------------------------------------------

#:------------------------------------------------------------
echo "Creating JSON key for service account..."
mkdir -p "$(dirname "$KEY_PATH")"
gcloud iam service-accounts keys create "$KEY_PATH" \
  --iam-account="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
echo "JSON key created in $KEY_PATH"
#:------------------------------------------------------------

echo "all done"