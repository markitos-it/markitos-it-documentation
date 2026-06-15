# Automatización de Base de Datos en Kubernetes: De Cero a Multi-Database en un Solo Script

Imagina que estás levantando la arquitectura de un nuevo ecosistema de microservicios. Tienes un servicio para autenticación (`access`), otro para el contenido (`articles`), uno para soporte (`faqs`), y un par de integraciones con APIs externas (`githubs` y `youtubes`). Cada uno de ellos necesita su propia base de datos aislada, su propio usuario dedicado y permisos perfectamente restringidos.

Hacer esto manualmente en PostgreSQL implica abrir un puerto hacia tu clúster, conectarse de forma interactiva al Pod y ejecutar comandos repetitivos, rezando para no cometer un error de dedo en las contraseñas.

¿La solución? Un script en Bash limpio, elegante y totalmente automatizado que transforma esta tediosa tarea en un proceso atómico de un solo clic utilizando la CLI de Kubernetes.

---

## El Script: Automatización Atómica para PostgreSQL en K8s

Aquí tienes la herramienta definitiva. Este script utiliza un array nativo de Bash para iterar secuencialmente sobre cada microservicio, interactuando directamente con el motor de PostgreSQL que corre dentro de un Pod específico en tu clúster mediante `kubectl exec`, sin necesidad de exponer servicios externamente o configurar Port-Forwards temporales.

```bash
#!/bin/bash

# Configuración del entorno en el clúster
NS="markitos-it"
POD="markitos-it-svc-database-xxxxxxxxxxxxxx-xxxxxx"
USER="markitos-it-svc-database"

DATABASES_WITH_CREDENTIALS=(
    "markitos_it_svc_access" 
    "markitos_it_svc_articles" 
    "markitos_it_svc_faqs" 
    "markitos_it_svc_githubs" 
    "markitos_it_svc_youtubes"
)

for DB in "${DATABASES_WITH_CREDENTIALS[@]}"; do
    echo "🚀 Configurando base de datos y usuario para: ${DB}..."
    
    # Ejecución encadenada dentro del Pod para asegurar atomicidad
    kubectl exec -n $NS -i $POD -- psql -U $USER -d postgres -c "CREATE DATABASE $DB;" && \
    kubectl exec -n $NS -i $POD -- psql -U $USER -d postgres -c "CREATE USER $DB WITH ENCRYPTED PASSWORD '$DB';" && \
    kubectl exec -n $NS -i $POD -- psql -U $USER -d $DB -c "GRANT ALL PRIVILEGES ON DATABASE $DB TO $DB; GRANT ALL ON SCHEMA public TO $DB;"
    
    if [ $? -eq 0 ]; then
        echo "✅ ¡${DB} configurada con éxito!"
    else
        echo "❌ Error al configurar la base de datos: ${DB}"
    fi
    echo "--------------------------------------------------------"
done

```

---

## Anatomía del Script: ¿Por qué es tan eficiente?

Para entender su robustez, piénsalo como una línea de ensamblaje automatizada en una fábrica de software. En lugar de que un operador construya cada pieza a mano corriendo el riesgo de equivocarse, el script actúa como un brazo robótico programado que ejecuta tres tareas cruciales por cada base de datos, asegurando que si un paso falla, el proceso se detenga inmediatamente para proteger la integridad del entorno.

### 1. El Flag `-i` en Kubectl (Interactividad sin TTY)

Al usar `kubectl exec -i`, le indicamos a Kubernetes que mantenga abierto el canal de entrada estándar (`stdin`) para pasarle los comandos a `psql`, pero evitamos el flag `-t` (TTY). Esto es crucial porque los scripts automatizados no necesitan una interfaz de terminal simulada; operar en modo "no-TTY" evita fallos y comportamientos extraños cuando se ejecutan en pipelines de CI/CD o tareas programadas.

### 2. Operadores Lógicos de Control (`&&`)

El uso de `&&` encadena las tres operaciones de PostgreSQL ejecutadas a través del clúster (Crear DB ➡️ Crear Usuario ➡️ Otorgar Permisos). Si la creación de la base de datos falla (por ejemplo, si ya existe), el flujo detiene la ejecución de esa iteración de inmediato, impidiendo que se intente crear un usuario huérfano o se apliquen permisos sobre un elemento inexistente.

### 3. Aislamiento de Privilegios y el Esquema Público

El último comando realiza una acción sutil pero vital: cambia el flag de conexión a `-d "${DB}"`. Al hacer esto, la instrucción `GRANT ALL ON SCHEMA public` se ejecuta **dentro del contexto de la base de datos recién creada**. Esto asegura que el nuevo usuario tenga control total sobre el esquema público de su propia aplicación y no interfiera con la base de datos global de administración del sistema (`postgres`).

---

## Ventajas de este Enfoque

* **Idempotencia y Consistencia**: Al definir los nombres en un único array centralizado, garantizas que el nombre de la base de datos, el usuario y la contraseña coincidan milimétricamente en tus entornos de desarrollo o laboratorios locales.
* **Seguridad por Aislamiento**: Cada microservicio nace con privilegios restringidos exclusivamente a su entorno. Si un servicio se ve comprometido, el atacante no tendrá visibilidad ni acceso al resto de las bases de datos que cohabitan en el mismo clúster.
* **Velocidad de Despliegue**: Pasar de cero a cinco entornos de almacenamiento completamente funcionales y aislados dentro de Kubernetes toma apenas unos segundos, de forma remota y segura.

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