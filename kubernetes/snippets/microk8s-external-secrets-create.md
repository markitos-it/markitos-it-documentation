# 1. Acceder de forma interactiva a la shell del Pod de Vault
microk8s kubectl exec -it vault-0 -n vault -- /bin/sh

# 2. Autenticarse en la CLI interna de Vault (Reemplazar con tu token real)
/bin/vault login TU_ROOT_TOKEN

# 3. Almacenar las credenciales de Gmail bajo una ruta limpia en el motor KV-v2
/bin/vault kv put secret/mis-apps/gmail \
    GMAIL_USERNAME="tu-correo@gmail.com" \
    GMAIL_APP_PASSWORD="abcd-efgh-ijkl-mnop"

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