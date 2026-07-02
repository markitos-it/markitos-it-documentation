## 🏛️ The Artisan's Knowledge Base 
# 🏛️MDK-HA CLUSTER: GUIA DE DESPLIEGUE INDESTRUCTIBLE (v1.30) - CKA READY

# 1. PREPARACION DE INFRAESTRUCTURA (TODOS LOS NODOS)
```bash
echo "# Configuracion Inicial de los Nodos Kubernetes"
sudo hostnamectl set-hostname markitos
echo "markitos ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/markitos
sudo swapoff -a
sudo sed -i '/swap/ s/^/#/' /etc/fstab

sudo apt update && sudo apt upgrade -y
sudo apt install -y ccze software-properties-common nano git sshpass locate curl apt-transport-https ca-certificates net-tools btop jq
sudo updatedb

sudo tee /etc/hosts <<EOF
127.0.0.1 localhost
127.0.1.1 \$HOSTNAME

::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters

#:{.'.}>----- markitos mdk k8s nodes -----
192.168.1.201 master1
192.168.1.202 master2
192.168.1.203 master3
192.168.1.221 titan1
192.168.1.222 titan2
192.168.1.223 titan3
192.168.1.224 titan4
192.168.1.225 titan5
#:{.'.}>----- markitos mdk k8s nodes -----
#:{.'.}>----- markitos mdk local domains -----
192.168.1.120 markitos.it.ing.test api.markitos.it.ing.test  www.markitos.it.ing.test  gateway.markitos.it.ing.test
192.168.1.121 markitos.it.gwadmin.test
192.168.1.122 markitos.it.gw.test api.markitos.it.gw.test www.markitos.it.gw.test gateway.markitos.it.gw.test
#:{.'.}>----- markitos mdk local domains -----
EOF

echo "# Modulos de Kernel para Red"
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

echo "# Parametros Sysctl"
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system

echo "Instalacion de Containerd (Runtime)"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update && sudo apt install -y containerd.io
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
sudo systemctl restart containerd && sudo systemctl enable containerd

echo "Instalacion de Componentes Kubernetes v1.30"
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update && sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

echo "Configuracion de Bashrc (Alias y Editor)"
cat <<EOF >> ~/.bashrc
# Alias MDK
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgn='kubectl get nodes'
alias kcl='clear'
# Autocompletado
source <(kubectl completion bash)
complete -F __start_kubectl k
export EDITOR=nano
export KUBE_EDITOR="nano"
EOF

echo "Fuente de .bashrc actualizada"
source ~/.bashrc  
echo "# Verificacion de Versiones"
kubeadm version
kubectl version --client
containerd --version

sudo apt update && sudo apt install -y qemu-guest-agent
sudo systemctl enable qemu-guest-agent
sudo systemctl start qemu-guest-agent
```


# 2. CONFIGURACION DE RED FIJA (EN CADA NODO)
```bash
# NUEVO_HOSTNAME="titan3"
# NUEVA_IP="192.168.1.223/24"
# GATEWAY="192.168.1.1"
# 
# sudo hostnamectl set-hostname $NUEVO_HOSTNAME
# sudo tee /etc/netplan/01-netcfg.yaml <<EOF
# network:
#  version: 2
#  renderer: networkd
#  ethernets:
#    ens18:
#      dhcp4: false
#      addresses:
#        - $NUEVA_IP
#      nameservers:
#        addresses: [8.8.8.8, 1.1.1.1]
#      routes:
#        - to: default
#          via: $GATEWAY
# EOF
# sudo chmod 600 /etc/netplan/01-netcfg.yaml && sudo netplan apply
# sudo reboot
```


# 3. ALTA DISPONIBILIDAD CON KUBE-VIP (SOLO MASTERS) POR EL MOMENTO NO USAMOS
## 1. Preparar la IP VIP en la interfaz para que kubeadm no se pierda (SOLO MASTER 1)
## SOLO EN MASTER 1 DESCOMENTAR LA SIGUIENTE LINEA
```bash
# sudo ip addr add 192.168.1.199/32 dev $(ip route get 8.8.8.8 | awk -- '{print $5}')
```
# 
## 2. Generar SOLO el manifiesto de kube-vip pero NO lo pongas aún en /etc/kubernetes/manifests
## Ponlo en /tmp para que no arranque antes de tiempo
```bash
# export VIP="192.168.1.199"
# export INTERFACE="ens18"
# export KVVERSION=$(curl -sL https://api.github.com/repos/kube-vip/kube-vip/releases/latest | jq -r .name)
# 
# sudo ctr image pull ghcr.io/kube-vip/kube-vip:$KVVERSION
# sudo ctr run --rm --net-host ghcr.io/kube-vip/kube-vip:$KVVERSION vip /kube-vip \
# manifest pod \
# --interface $INTERFACE \
# --address $VIP \
# --controlplane \
# --services \
# --arp \
# --leaderElection | sudo tee /tmp/kube-vip.yaml
## tras el join de los otros masters, mover este manifiesto a /etc/kubernetes/manifests/ con:
## sudo mv /tmp/kube-vip.yaml /etc/kubernetes/manifests/
```
# -------------------------------------------------------------------------------


-------------------------------------------------------------------------------
4. INICIALIZACION (SOLO MASTER 1)
-------------------------------------------------------------------------------
```bash
sudo kubeadm init --pod-network-cidr=10.10.0.0/16 --control-plane-endpoint="master1:6443" --upload-certs
echo "Cluster inicializado. Ejecuta los comandos de join en los otros nodos."

# Configuracion de kubectl para el usuario no root
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#kubectl apply -f https://kube-vip.io/manifests/rbac.yaml
#sudo mv /tmp/kube-vip.yaml /etc/kubernetes/manifests/
#kubectl create clusterrolebinding kubelet-api-admin --clusterrole=cluster-admin --user=kube-apiserver-kubelet-client
```

# calico installation
```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/tigera-operator.yaml
curl -O https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/custom-resources.yaml
sed -i 's/192.168.0.0\/16/10.10.0.0\/16/g' custom-resources.yaml
kubectl apply -f custom-resources.yaml
```

# Instalacion de K9s
```bash
curl -LO https://github.com/derailed/k9s/releases/download/v0.50.18/k9s_Linux_amd64.tar.gz
tar xvfz k9s_Linux_amd64.tar.gz
sudo mv k9s /usr/local/bin/
k9s version
rm LICENSE README.md
```

# Instalacion de Metrics Server
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl patch deployment metrics-server -n kube-system --type='json' -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'
sleep 10
kubectl get deployment metrics-server -n kube-system
kubectl top nodes
kubectl top pods -A
```

# Helm 4 installation
```bash
wget https://get.helm.sh/helm-v4.0.5-linux-amd64.tar.gz
tar -zxvf helm-v4.0.5-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
helm version
```
-------------------------------------------------------------------------------

# ANEXO: INSTALACION DE METALLB (CAPA 2)
```bash
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed 's/strictARP: false/strictARP: true/' | \
kubectl apply -f -
kubectl rollout restart daemonset kube-proxy -n kube-system

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.5/config/manifests/metallb-native.yaml
kubectl wait --namespace metallb-system --for=condition=ready pod --selector=app=metallb --timeout=90s

kubectl apply -f - <<EOF
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.120-192.168.1.130
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: homelab-advertisement
  namespace: metallb-system
spec:
  ipAddressPools:
  - first-pool
EOF
```

# FACTORY RESET PROFUNDO DE METALLB E INGRESS NGINX + GATEWAY API
```bash
echo "# CLEAN METALLB INGRESS AND GATEWAY API"
echo "🔥 Iniciando FACTORY RESET PROFUNDO..."

echo "# 1. Borrar Namespaces y GatewayClass"
kubectl delete namespace nginx-gateway ingress-nginx metallb-system --ignore-not-found=true
kubectl delete gatewayclass nginx --ignore-not-found=true

echo "# 2. Limpiar CRDs de MetalLB, NGINX y Gateway API"
kubectl delete crd gateways.gateway.networking.k8s.io gatewayclasses.gateway.networking.k8s.io httproutes.gateway.networking.k8s.io referencegrants.gateway.networking.k8s.io grpcroutes.gateway.networking.k8s.io --ignore-not-found=true
kubectl delete -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.3.0/deploy/crds.yaml --ignore-not-found=true
kubectl delete -f https://raw.githubusercontent.com/metallb/metallb/v0.14.5/config/manifests/metallb-native.yaml --ignore-not-found=true

echo "# 3. Eliminar Webhooks residuales (Suelen causar bloqueos)"
kubectl delete validatingwebhookconfiguration ingress-nginx-admission --ignore-not-found=true
kubectl delete validatingwebhookconfiguration metallb-webhook-configuration --ignore-not-found=true

echo "# 4. Limpiar RBAC Global"
kubectl delete clusterrole ingress-nginx nginx-gateway metallb-system:controller metallb-system:speaker --ignore-not-found=true
kubectl delete clusterrolebinding ingress-nginx nginx-gateway metallb-system:controller metallb-system:speaker --ignore-not-found=true

echo "🧹 Esperando a que el clúster purgue los recursos..."
kubectl wait --for=delete namespace/nginx-gateway --timeout=60s 2>/dev/null
kubectl wait --for=delete namespace/ingress-nginx --timeout=60s 2>/dev/null
kubectl wait --for=delete namespace/metallb-system --timeout=60s 2>/dev/null

echo "✅ Reset completado."
echo "--------------------------------------------------------"
echo "🔍 VERIFICACIÓN DE CLÚSTER LIMPIO:"

echo "1. Namespaces (No deberían salir los borrados):"
kubectl get ns | grep -E 'nginx|metallb' || echo "✔️ Namespaces limpios"

echo "2. CRDs de Gateway API (Debería estar vacío):"
kubectl get crd | grep -E 'gateway|metallb|nginx' || echo "✔️ CRDs eliminados"

echo "3. Webhooks de validación (Crítico para reinstalar):"
kubectl get validatingwebhookconfiguration | grep -E 'nginx|metallb' || echo "✔️ Webhooks eliminados"

echo "4. IPs de MetalLB (No debería haber Services LoadBalancer):"
kubectl get svc -A | grep 'LoadBalancer' || echo "✔️ IPs liberadas"

kubectl delete namespace nginx-gateway ingress-nginx metallb-system --ignore-not-found=true
kubectl delete gatewayclass nginx --ignore-not-found=true

echo "✨ Clúster listo para una instalación desde cero."
```



# PARTE 1: FACTORY RESET (LIMPIEZA TOTAL)
```bash
echo "🔥 1. Iniciando limpieza profunda..."
kubectl delete namespace nginx-gateway ingress-nginx metallb-system --ignore-not-found=true
kubectl delete gatewayclass nginx --ignore-not-found=true

echo "# Limpieza de CRDs y Webhooks residuales"
kubectl delete crd gateways.gateway.networking.k8s.io gatewayclasses.gateway.networking.k8s.io httproutes.gateway.networking.k8s.io referencegrants.gateway.networking.k8s.io grpcroutes.gateway.networking.k8s.io --ignore-not-found=true
kubectl delete validatingwebhookconfiguration ingress-nginx-admission metallb-webhook-configuration --ignore-not-found=true

echo "🧹 Esperando purga de namespaces..."
kubectl wait --for=delete namespace/nginx-gateway --timeout=60s 2>/dev/null
echo "✅ Clúster como una patena."

echo "# PARTE 2: INSTALACIÓN CORE (METALLB)"
echo "🚀 2. Configurando MetalLB..."
kubectl get configmap kube-proxy -n kube-system -o yaml | sed 's/strictARP: false/strictARP: true/' | kubectl apply -f -
kubectl rollout restart daemonset kube-proxy -n kube-system

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.5/config/manifests/metallb-native.yaml
kubectl wait --namespace metallb-system --for=condition=ready pod --selector=app=metallb --timeout=90s

kubectl apply -f - <<EOF
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: main-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.120-192.168.1.130
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: l2-adv
  namespace: metallb-system
spec:
  ipAddressPools:
  - main-pool
EOF

echo "# PARTE 3: INGRESS NGINX CLASSIC"
echo "🚀 3. Desplegando Ingress Nginx..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.1/deploy/static/provider/cloud/deploy.yaml
kubectl patch svc ingress-nginx-controller -n ingress-nginx -p '{"spec": {"type": "LoadBalancer"}}'

echo "# PARTE 4: GATEWAY API (NGINX FABRIC) - EL "MODO MAESTRO""
echo "🚀 4. Instalando Gateway API Fabric..."

echo " A. Instalación de CRDs con --server-side para evitar errores de tamaño de bytes"
echo "📦 Aplicando CRDs (Server-Side)..."
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.2.0/deploy/crds.yaml --server-side

echo " B. Instalación con corrección de TLS en un solo paso"
echo "⚙️ Desplegando controlador con fix TLS..."
curl -s https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.2.0/deploy/default/deploy.yaml | \
sed 's/--agent-tls-secret=agent-tls/--agent-tls-secret=server-tls/' | \
kubectl apply -f -

echo "⏳ Esperando certificados..."
kubectl wait --for=condition=complete job/nginx-gateway-cert-generator -n nginx-gateway --timeout=60s

echo  C. Optimización de Red y Alta Disponibilidad
kubectl patch deployment nginx-gateway -n nginx-gateway -p '{"spec":{"replicas":2}}'
kubectl patch svc nginx-gateway -n nginx-gateway -p '{"spec":{"type":"LoadBalancer","externalTrafficPolicy":"Cluster"}}'


echo " D. Creación del Gateway NGINX"
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: home-gateway
  namespace: nginx-gateway
spec:
  gatewayClassName: nginx
  listeners:
  - name: http
    port: 80
    protocol: HTTP
    allowedRoutes:
      namespaces:
        from: All
EOF
sleep 10
echo "--------------------------------------------------------"
echo "🔍 Verificando despliegue final..."
echo "--------------------------------------------------------"
echo "✅ INSTALACIÓN V1.0 COMPLETADA SIN PARCHES"
echo "--------------------------------------------------------"
kubectl get pods -n nginx-gateway
kubectl get svc -A | grep -E "ingress-nginx-controller|nginx-gateway"
```
Cambio de puertos de nginx si se desea :)
```bash
kubectl patch svc ingress-nginx-controller -n ingress-nginx --type='json' -p='[
  {"op": "replace", "path": "/spec/ports/0/nodePort", "value": 30080},
  {"op": "replace", "path": "/spec/ports/1/nodePort", "value": 30443}
]'
```

# comandos utiles
```bash
sudo kubeadm token create --print-join-command
```




REVISAR

¡Excelente pregunta, Markitos! Para entender qué pasaría con la **.121**, primero tenemos que entender el concepto de **Plano de Control** vs. **Plano de Datos**.

### ¿Qué pasaría con la 121?

**Absolutamente nada.** La **.121** seguiría existiendo tal cual la ves ahora: como la "oficina de administración" interna del controlador de NGINX Gateway Fabric.

En la arquitectura de NGINX Fabric:

* **La .121 (Plano de Control/Admin):** Es donde el controlador "habla" consigo mismo y con sus agentes. No es una IP pensada para servir tu página web. Por eso, aunque le pongas HTTPS a la .122, la .121 seguirá dando ese error de SSL porque solo acepta conexiones con certificados de "agente" específicos.
* **La .122 (Plano de Datos):** Al configurar HTTPS aquí, esta se convertiría en tu "Puerta Principal de Lujo". Seguiría siendo la IP donde tus usuarios (o tú) entran para ver la aplicación, pero ahora con el candadito de seguridad.

---

### Paso 1: Crear un Certificado (Secret)

Para que la **.122** sirva HTTPS, necesitamos un certificado. Como estamos en un laboratorio, crearemos uno auto-firmado:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout tls.key -out tls.crt \
  -subj "/CN=modern.markitos.lab"

kubectl create secret tls o-secret-cert --key tls.key --cert tls.crt -n nginx-gateway

```

---

### Paso 2: Configurar el Gateway para HTTPS (El "Upgrade")

Ahora vamos a decirle a tu `home-gateway` que, además de escuchar en el puerto 80, también escuche en el **443** usando ese certificado.

Aplica este YAML (esto actualizará tu Gateway actual):

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: home-gateway
  namespace: nginx-gateway
spec:
  gatewayClassName: nginx
  listeners:
  - name: http
    port: 80
    protocol: HTTP
    allowedRoutes:
      namespaces:
        from: All
  - name: https # <--- Nuevo Listener
    port: 443
    protocol: HTTPS
    tls:
      mode: Terminate # El Gateway descifra el tráfico y lo pasa en HTTP a la app
      certificateRefs:
      - name: o-secret-cert
    allowedRoutes:
      namespaces:
        from: All

```

---

### Profundizando: ¿Por qué esto es más profesional?

Al añadir el listener de HTTPS, estás haciendo lo que se llama **TLS Termination**. El Gateway se encarga del trabajo pesado de cifrar y descifrar, y tu aplicación (`app-test`) puede seguir siendo sencilla y trabajar en HTTP por dentro del clúster.

**Analógicamente:** Es como si el Gateway fuera un **traductor**. El cliente le habla en un idioma complejo y cifrado (HTTPS), el Gateway lo traduce a un idioma simple (HTTP) y se lo pasa a la aplicación en la cocina para que no pierda tiempo traduciendo.

---

### ¿Cómo probarlo ahora?

Una vez aplicado, verás que la **.122** ahora tiene dos puertos:

```bash
kubectl get svc -n nginx-gateway

```

Y podrás hacer la prueba de fuego:

```bash
# Debería responder con el 200 OK y mostrar los datos del certificado
curl -kI https://192.168.1.122/test
```

