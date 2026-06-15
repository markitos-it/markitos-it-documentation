
# Proyecto Terraform GCP: GKE Estándar Privado + Bastion

## Descripción
Este stack despliega un clúster GKE privado en Google Cloud Platform (GCP), con nodos sin IP pública y acceso seguro mediante una instancia bastion. Incluye la infraestructura de red, reglas de firewall, NAT, bastion y todos los recursos necesarios para operar el clúster de forma segura y aislada.

---

## Acciones disponibles en el Makefile

- `make init`: Inicializa el entorno de Terraform.
- `make plan`: Muestra el plan de ejecución.
- `make apply`: Aplica los cambios definidos en la infraestructura.
- `make destroy`: Elimina la infraestructura creada.
- `make validate`: Valida la sintaxis y configuración.
- `make list`: Lista los recursos gestionados por Terraform.
- `make show`: Muestra detalles de un recurso específico (`make show uri="google_container_cluster.cluster_name"`).
- `make clean`: Elimina archivos y carpetas generados por Terraform.
- `make install-terraform`: Instala la versión recomendada de Terraform.

---

## Variables principales (`variables.tf`)

- `region`: Región de GCP (default: `us-central1`)
- `project_id`: ID del proyecto (default: `markitos-es-ops`)
- `project`: Nombre del proyecto (default: `markitos-es`)
- `environment`: Entorno (`dev`, `staging`, `prod`)
- `team`: Equipo responsable (default: `devops`)
- `network_ssh_tags`: Tags para hosts con acceso SSH
- `firewall_ports`: Puertos permitidos en firewall (default: `["22"]`)
- `subnet_ip_range`, `pods_ip_range`, `services_ip_range`, `master_ip_range`: Rangos de IP para red y clúster

---

## Locales (`locals.tf`)

- `prefix`: Prefijo común para recursos
- `service_account_path`: Ruta al archivo de credenciales
- `network_ssh_tags`: Tags SSH con prefijo personalizado
- `deletion_cluster_protection`: Protección contra eliminación en `prod`
- `cluster_zone_location`, `cluster_node_locations`: Zonas del clúster
- `common_tags`: Tags comunes para todos los recursos

---

## Backend (`versions.tf`)

- **Backend GCS**: Estado de Terraform en Google Cloud Storage
  - `bucket`: `markitos-es-terraform-states`
  - `prefix`: `dev/markitos-es-devops`
- **Provider Google**: Configurado con variables de proyecto, región y credenciales
- **Versiones requeridas**:
  - Terraform: `>= 1.12.0, < 2.0.0`
  - Provider Google: `>= 6.0.0`

---

## Requisitos

- Archivo de credenciales configurado en la ruta indicada en `locals.tf`
- Permisos suficientes en GCP para crear recursos
- Terraform >= 1.12.0

---

## Uso rápido

```bash
make init
make plan
make apply
```

---

## 🔐 Acceso seguro por IAP al bastion y a los nodos privados

Cuando todo el clúster y los nodos son privados, la forma recomendada de acceso es mediante el bastion usando IAP (Identity-Aware Proxy). Desde el bastion, puedes acceder por SSH a los nodos privados.

Conéctate al bastion usando:

```bash
gcloud compute ssh markitos-es-dev-devops-bastion \
    --zone=us-central1-a \
    --project=markitos-es-gcp-infrastructure \
    --tunnel-through-iap
```

Una vez dentro del bastion, podrás hacer SSH a los nodos privados del clúster, siempre que tengas las claves y permisos necesarios.

### 📦 Copiar archivos al bastion usando IAP

Puedes enviar uno o más ficheros al bastion con:

```bash
gcloud compute scp --zone=us-central1-a \
    --tunnel-through-iap \
    --project=markitos-es-gcp-infrastructure \
    archivo1.txt archivo2.sh \
    markitos-es-dev-devops-bastion:~/

gcloud compute scp --recurse manifests/  \
    markitos-es-dev-devops-bastion:~/ \
    --zone=us-central1-a \
    --project=markitos-es-gcp-infrastructure \
    --tunnel-through-iap
```

Asegúrate de tener la clave SSH correspondiente en el bastion y que las reglas de firewall permitan el acceso.

**Requisitos:**
- Rol `IAP-secured Tunnel User` y permisos de acceso SSH en el proyecto
- Bastion en la misma VPC/subred que los nodos privados
- Reglas de firewall que permitan tráfico SSH interno (puerto 22) desde el bastion a los nodos

**Referencia:** [Documentación oficial de IAP para SSH](https://cloud.google.com/iap/docs/using-tcp-forwarding)

---

## Permisos del Rol Personalizado

desde dentro del directorio gcloud-role-permissions-sa podemos crear tanto el role permisos sa y el binding

custom role id....: markitos_es_mdk_terraform_role
custom svc account: markitos-es-mdk-terraform-sa
project id........: mdk-pipelines

```sh
cd gcloud-role-permissions-sa
echo
echo "remove the echo before gcloud command for real execution.\nwaiting 10seconds before execute.... CTRL+C to interrupt"
echo
sleep 10

ROLE_ID=markitos_es_mdk_terraform_role
SERVICE_ACCOUNT_NAME=markitos-es-mdk-terraform-sa
PROJECT_ID=mdk-pipelines

echo
sleep 5
echo gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
  --project=${PROJECT_ID} \
  --display-name="Service Account for Terraform"

echo
sleep 5
echo gcloud services enable compute.googleapis.com \
  --project=${PROJECT_ID} \
  container.googleapis.com \
  iam.googleapis.com \
  storage.googleapis.com

echo
sleep 5
echo gcloud iam roles create $ROLE_ID \
  --project=${PROJECT_ID} \
  --title="Custom Role for Terraform" \
  --description="Rol personalizado para Terraform con permisos mínimos necesarios" \
  --permissions="$(paste -sd, - < terraform-custom-role-permissions.list)" \
  --stage="GA"

echo
sleep 5
gcloud projects add-iam-policy-binding mdk-pipelines \
  --member="serviceAccount:${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="projects/{PROJECT_ID}/roles/${ROLE_ID}"
```

## Autor

**Marco Antonio - markitos**  
DevSecOps Kulture  
El Camino del Artesano

---

## Licencia

MIT License  
Este proyecto se distribuye bajo la licencia MIT. Puedes usar, modificar, copiar y distribuir el código libremente, con o sin fines comerciales, siempre que se conserve el aviso de copyright y la licencia original.

---
