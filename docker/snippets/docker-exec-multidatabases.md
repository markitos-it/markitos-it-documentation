# Automatización de Base de Datos en Docker: De Cero a Multi-Database en un Solo Script

Imagina que estás levantando la arquitectura de un nuevo ecosistema de microservicios. Tienes un servicio para autenticación (`access`), otro para el contenido (`articles`), uno para soporte (`faqs`), y un par de integraciones con APIs externas (`githubs` y `youtubes`). Cada uno de ellos necesita su propia base de datos aislada, su propio usuario dedicado y permisos perfectamente restringidos.

Hacer esto manualmente en PostgreSQL implica conectarse al contenedor, ejecutar comandos interactivos repetitivos y rezar para no cometer un error de dedo en las contraseñas.

¿La solución? Un script en Bash limpio, elegante y totalmente automatizado que transforma esta tediosa tarea en un proceso atómico de un solo clic.

---

## El Script: Automatización Atómica para PostgreSQL

Aquí tienes la herramienta definitiva. Este script utiliza un array nativo de Bash para iterar secuencialmente sobre cada microservicio, interactuando directamente con el motor de PostgreSQL que corre dentro de tu contenedor Docker sin necesidad de exponer puertos o abrir clientes externos.

```bash
DATABASES_WITH_CREDENTIALS=(
    "markitos_it_svc_access" 
    "markitos_it_svc_articles" 
    "markitos_it_svc_faqs" 
    "markitos_it_svc_githubs" 
    "markitos_it_svc_youtubes"
)
CONTAINER_NAME="markitos-it-markitos-it-svc-database-1"
DB_USER="markitos-it-svc-database"

for DB_NEW in "${DATABASES_WITH_CREDENTIALS[@]}"; do
    echo "🚀 Configurando base de datos y usuario para: ${DB_NEW}..."
    
    docker exec -i "${CONTAINER_NAME}" psql -U "${DB_USER}" -d postgres -c "CREATE DATABASE ${DB_NEW};" && \
    docker exec -i "${CONTAINER_NAME}" psql -U "${DB_USER}" -d postgres -c "CREATE USER ${DB_NEW} WITH ENCRYPTED PASSWORD '${DB_NEW}';" && \
    docker exec -i "${CONTAINER_NAME}" psql -U "${DB_USER}" -d "${DB_NEW}" -c "GRANT ALL PRIVILEGES ON DATABASE ${DB_NEW} TO ${DB_NEW}; GRANT ALL ON SCHEMA public TO ${DB_NEW};"
    
    echo "✅ ¡${DB_NEW} configurada con éxito!"
    echo "--------------------------------------------------------"
done

```

---

## Anatomía del Script: ¿Por qué es tan eficiente?

Para entender su robustez, piénsalo como una línea de ensamblaje automatizada en una fábrica de software. En lugar de que un operador construya cada pieza a mano corriendo el riesgo de equivocarse, el script actúa como un brazo robótico programado que ejecuta tres tareas cruciales por cada base de datos, asegurando que si un paso falla, el proceso se detenga inmediatamente para proteger la integridad del entorno.

### 1. El Flag `-i` en Docker (Interactividad sin TTY)

Al usar `docker exec -i`, le indicamos a Docker que mantenga abierto el canal de entrada estándar (`stdin`) para pasarle comandos a `psql`, pero evitamos el flag `-t` (TTY). Esto es crucial porque los scripts automatizados no necesitan una interfaz de terminal simulada; operar en modo "silencioso" evita bugs cuando se ejecutan en pipelines de CI/CD o crontabs.

### 2. Operadores Lógicos de Control (`&&`)

El uso de `&&` encadena las tres operaciones de PostgreSQL (Crear DB ➡️ Crear Usuario ➡️ Otorgar Permisos). Si la creación de la base de datos falla (por ejemplo, si ya existe), el script detiene la ejecución de esa iteración de inmediato, impidiendo que se intente crear un usuario huérfano o se apliquen permisos sobre la nada.

### 3. Aislamiento de Privilegios y el Esquema Público

El último comando realiza una acción sutil pero vital: cambia el flag de conexión a `-d "${DB_NEW}"`. Al hacer esto, la instrucción `GRANT ALL ON SCHEMA public` se ejecuta **dentro del contexto de la base de datos recién creada**. Esto asegura que el nuevo usuario tenga control total sobre el esquema público de su propia aplicación y no interfiera con la base de datos global de administración (`postgres`).

---

## Ventajas de este Enfoque

* **Idempotencia y Consistencia**: Al definir los nombres en un único array centralizado, garantizas que el nombre de la base de datos, el usuario y la contraseña coincidan milimétricamente en tus entornos de desarrollo local.
* **Seguridad por Aislamiento**: Cada microservicio nace con privilegios restringidos exclusivamente a su entorno. Si un servicio se ve comprometido, el atacante no tendrá visibilidad ni acceso al resto de las bases de datos del sistema.
* **Velocidad de Despliegue**: Pasar de cero a cinco entornos de almacenamiento completamente funcionales toma menos de tres segundos.

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