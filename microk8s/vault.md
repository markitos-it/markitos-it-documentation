## 🏗️ Paso 1: Instalación de los CRDs Estables (Server-Side)

Debido al gran volumen de proveedores que soporta External Secrets Operator, los CRDs completos exceden el límite de tamaño de las anotaciones tradicionales de Kubernetes. Los instalamos forzando el procesamiento en el servidor:

```bash
microk8s kubectl apply -f https://raw.githubusercontent.com/external-secrets/external-secrets/main/deploy/crds/bundle.yaml --server-side

```

---

## 🚀 Paso 2: Instalación del Operador (Helm)

Una vez que el clúster entiende los recursos, desplegamos los controladores de ESO en su propio namespace diciéndole a Helm que no intente machacar los CRDs que ya inyectamos:

```bash
# Registrar y actualizar repositorio
microk8s helm3 repo add external-secrets https://charts.external-secrets.io
microk8s helm3 repo update

# Instalar controladores operativos
microk8s helm3 install external-secrets external-secrets/external-secrets \
    --namespace external-secrets \
    --create-namespace \
    --set installCRDs=false

```

---

## 🔒 Paso 3: Configuración en Vault (Fuente de la Verdad)

Antes de que Kubernetes pueda pedir datos, las credenciales deben existir dentro de tu motor de almacenamiento KV versión 2 en Vault:

```bash
# Entrar al pod de Vault e iniciar sesión
microk8s kubectl exec -it vault-0 -n vault -- /bin/sh
/bin/vault login TU_ROOT_TOKEN

# Almacenar las credenciales bajo una ruta limpia
/bin/vault kv put secret/mis-apps/gmail \
    GMAIL_USERNAME="tu-correo@gmail.com" \
    GMAIL_APP_PASSWORD="abcd-efgh-ijkl-mnop"

```

---

## 📄 Paso 4: Los Manifiestos Completos de Kubernetes

Crea un único archivo unificado o divídelo por componentes. Aquí tienes toda la declaración de infraestructura y despliegue:

```yaml
# ==========================================
# 1. EL PUENTE GLOBAL (ClusterSecretStore)
# ==========================================
apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: vault-backend
spec:
  provider:
    vault:
      server: "http://vault.vault.svc.cluster.local:8200"
      path: "secret"
      version: "v2"
      auth:
        kubernetes:
          mountPath: "kubernetes"
          role: "eso-role"
          serviceAccountRef:
            name: external-secrets
            namespace: external-secrets

---
# ==========================================
# 2. EL EXTRACTOR (ExternalSecret)
# ==========================================
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: gmail-credentials
  namespace: markitos-it
spec:
  refreshInterval: "5m"
  secretStoreRef:
    name: vault-backend
    kind: ClusterSecretStore
  target:
    name: k8s-gmail-secret # Nombre del secreto nativo que se creará automáticamente
    creationPolicy: Owner
  data:
    - secretKey: GMAIL_USERNAME
      remoteRef:
        key: mis-apps/gmail
        property: GMAIL_USERNAME
    - secretKey: GMAIL_APP_PASSWORD
      remoteRef:
        key: mis-apps/gmail
        property: GMAIL_APP_PASSWORD

---
# ==========================================
# 3. EL CONSUMIDOR (Deployment)
# ==========================================
apiVersion: apps/v1
kind: Deployment
metadata:
  name: markitos-it-app-personal-portfolio
  namespace: markitos-it
  labels:
    name: markitos-it-app-personal-portfolio
    team: operations
    environment: production
    owner: markitos
    role: infrastructure
    project: markitos-it-personal-project
    kind: service
    app: markitos-it-app-personal-portfolio
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: markitos-it-app-personal-portfolio
  template:
    metadata:
      labels:
        name: markitos-it-app-personal-portfolio
        team: operations
        environment: production
        owner: markitos
        role: infrastructure
        project: markitos-it-personal-project
        kind: deployment
        app: markitos-it-app-personal-portfolio
    spec:
      imagePullSecrets:
        - name: pull-from-gcp-artifact-registry-json-key
      containers:
        - name: app
          image: europe-southwest1-docker.pkg.dev/markitos-it-local/images/markitos-it-app-personal-portfolio:v0.0.6
          imagePullPolicy: Always
          ports:
            - name: http
              containerPort: 8080
              protocol: TCP
          env:
            - name: ENVIRONMENT
              value: "production"
            - name: APP_PORT 
              value: "8080"
            - name: SERVICE_PORT 
              value: "8080"
          # Inyección en bloque de todas las llaves del secreto sincronizado
          envFrom:
            - secretRef:
                name: k8s-gmail-secret
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 300m
              memory: 256Mi

---
# ==========================================
# 4. EL ACCESO (Service)
# ==========================================
apiVersion: v1
kind: Service
metadata:
  name: markitos-it-app-personal-portfolio
  namespace: markitos-it
  labels:
    name: markitos-it-app-personal-portfolio
    team: operations
    environment: production
    owner: markitos
    role: infrastructure
    project: markitos-it-personal-project
    kind: k8s-service
    app: markitos-it-app-personal-portfolio
spec:
  type: NodePort
  selector:
    app: markitos-it-app-personal-portfolio
  ports:
    - name: http
      port: 8080
      targetPort: http
      nodePort: 32040

```

---

## 🛠️ Paso 5: Comandos de Verificación y Diagnóstico

Para validar paso a paso que los engranajes se están moviendo como deben, usa esta batería de comandos:

1. **Comprobar el estado de salud de los pods del operador:**
```bash
microk8s kubectl get pods -n external-secrets

```


2. **Monitorear la sincronización en caliente desde Vault:**
```bash
microk8s kubectl get externalsecrets -n markitos-it
# Debe mostrar STATUS: SecretSynced y READY: True

```


3. **Validar la existencia del secreto inyectado por ESO:**
```bash
microk8s kubectl get secret k8s-gmail-secret -n markitos-it -o yaml

```


4. **Verificar que las réplicas del portafolio devoran el entorno:**
```bash
microk8s kubectl get pods -n markitos-it -l app=markitos-it-app-personal-portfolio

```