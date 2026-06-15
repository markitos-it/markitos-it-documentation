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
echo "creating service account: ${SERVICE_ACCOUNT_NAME}"
sleep 0.5
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
  --project=${PROJECT_ID} \
  --display-name="Service Account for Terraform"
echo "service account created"
sleep 2
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
sleep 0.5
gcloud iam roles create $ROLE_ID \
  --project=${PROJECT_ID} \
  --title="Custom Role for Terraform" \
  --description="Custom role for Terraform with minimum required permissions" \
  --permissions="$(paste -sd, - < ./terraform-custom-role-permissions.list)" \
  --stage="GA"
echo "role created"
sleep 2
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
# Create a JSON key for the service account
#:------------------------------------------------------------
echo "Creating JSON key for service account..."
mkdir -p "$(dirname "$KEY_PATH")"
gcloud iam service-accounts keys create "$KEY_PATH" \
  --iam-account="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
echo "JSON key created in $KEY_PATH"
#:------------------------------------------------------------

echo
echo "all done"
echo



#:[.'.]:> # comment for dry-run mode :D remove echo to execute,
#:[.'.]:> # this is for updating the role permissions later if needed
#echo
#sleep 2 
#gcloud iam roles update $ROLE_ID \
#  --project=${PROJECT_ID} \
#  --permissions="$(paste -sd, - < terraform-custom-role-permissions.list)"