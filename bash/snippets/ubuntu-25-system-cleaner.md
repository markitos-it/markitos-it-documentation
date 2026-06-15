# Saneamiento Avanzado del Espacio de Trabajo

Este script automatiza una limpieza profunda y segura en entornos Ubuntu, eliminando cachés persistentes y dependencias huérfanas sin comprometer la estabilidad del sistema operativo.

## Código de Optimización Ejecutable

```bash
#!/usr/bin/env bash
set -euo pipefail

# ubuntu-25-system-cleaner.sh - Script para limpiar y optimizar sistemas Ubuntu 25

echo ""
echo ""
echo "🧹 Iniciando limpieza quirúrgica..."
echo "🔍 Eliminando paquetes huérfanos de Go..."
go clean -modcache -cache

echo "🔍 Eliminando paquetes huérfanos de Snap..."
snap list --all | awk '/desactivado/{print $1, $3}' | while read -r snapname rev; do 
    sudo snap remove "$snapname" --revision="$rev"
done

echo "🔍 Limpiando caché y logs..."
rm -rf ~/.cache/thumbnails/*
sudo journalctl --vacuum-time=3d

echo "🔍 Limpiando caché de Code..."
rm -rf ~/.config/Code/CachedData/*

echo "🔍 Limpiando caché de Google Chrome..."
rm -rf ~/.config/google-chrome/Default/Cache/*
rm -rf ~/.config/google-chrome/ShaderCache/*

echo "🔍 Limpiando paquetes huérfanos de APT..."
sudo apt autoremove --purge -y

echo "🔍 Limpiando caché de APT..."
sudo apt autoclean

echo ""
echo "✅ Teseo está optimizado."
echo ""
echo ""

```

## Anatomía de la Limpieza del Sistema

Para comprender la necesidad de ejecutar este mantenimiento, es fundamental analizar el comportamiento de almacenamiento de los diferentes subsistemas que interactúan en una estación de trabajo moderna.

### Purga del Entorno de Compilación en Go

El comando `go clean -modcache -cache` interviene directamente sobre dos directorios críticos administrados por el compilador de Go:

* **`-cache`**: Elimina el directorio de caché de construcción del SDK. Go almacena aquí los objetos compilados de ejecutable y paquetes anteriores para acelerar las compilaciones consecutivas. Sin embargo, cuando se trabaja activamente en múltiples proyectos distribuidos o microservicios que cambian de dependencias con frecuencia, esta caché retiene binarios intermedios de versiones antiguas que jamás volverán a ser invocados.
* **`-modcache`**: Vacía el directorio donde se descargan y descomprimen los módulos de terceros (por defecto en `$GOPATH/pkg/mod`). Go trata este directorio como de "solo lectura" para garantizar la inmutabilidad de las dependencias durante el desarrollo. Con el tiempo, la continua actualización de bibliotecas externas satura los nodos de indexación (inodes) del sistema de archivos. Forzar su vaciado asegura que la próxima descarga e indexación partan de un estado completamente limpio y reproducible.

### Gestión de Residuos en Paquetes Snap

El ecosistema Snap prioriza la disponibilidad y la capacidad de recuperación ante fallos del software. Para lograrlo, cuando una herramienta empaquetada como Snap se actualiza, el demonio `snapd` no elimina la versión anterior de inmediato; en su lugar, conserva la revisión antigua en el disco y la marca con el estado de `desactivado`.

El pipeline del script filtra estas revisiones inactivas mediante un procesamiento de cadenas con `awk` y las elimina de forma dirigida con `snap remove --revision`. En entornos con actualizaciones frecuentes, este paso puede recuperar de inmediato decenas de gigabytes, ya que los snaps se montan como imágenes completas de sistemas de archivos comprimidos (`squashfs`).

### Rotación de Bitácoras del Sistema y Limpieza de Entornos de Desarrollo

Las aplicaciones de software diarias generan un volumen constante de datos volátiles:

* **`journalctl --vacuum-time=3d`**: El recolector de logs de Systemd (`systemd-journald`) almacena registros detallados de los servicios del sistema de forma persistente. Sin límites estrictos, estos diarios crecen sin control. Restringir el almacenamiento a los últimos 3 días garantiza un histórico suficiente para la depuración de fallos locales recientes, impidiendo que los ficheros de log monopolicen el almacenamiento del disco duro.
* **Caché de IDEs y Navegadores**: Tanto VS Code (`Code/CachedData`) como Google Chrome almacenan en caché datos precompilados, scripts indexados y capas de sombreadores gráficos (`ShaderCache`). Borrar periódicamente estos directorios resuelve problemas comunes de corrupción de interfaz de usuario, optimiza el rendimiento del motor de renderizado y libera bloques del sistema de archivos.

### Consolidación del Gestor de Paquetes Tradicional

El gestor APT mantiene un registro estricto de las dependencias instaladas en el sistema operativo:

* **`apt autoremove --purge`**: Cuando se instala una herramienta, APT resuelve e instala automáticamente sus bibliotecas requeridas. Si la herramienta principal se desinstala, las dependencias a menudo quedan huérfanas en el sistema. El modificador `--purge` asegura que no solo se eliminen los binarios sueltos, sino también sus archivos de configuración residuales en `/etc`, garantizando la higiene absoluta del sistema de archivos.
* **`apt autoclean`**: A diferencia de `clean` (que borra todos los paquetes descargados), `autoclean` elimina exclusivamente los archivos `.deb` que han quedado obsoletos de la caché de APT (`/var/cache/apt/archives`). Esto significa que si un paquete ya no está disponible en los repositorios oficiales de la distribución por haber sido superado por una versión más reciente, su instalador antiguo es eliminado de inmediato.

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