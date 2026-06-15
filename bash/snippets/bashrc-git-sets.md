# 🥷 The Way of the Artisan: Entorno & Git Config

Bienvenido a la configuración de entorno personalizada de **Markitos DevSecOps Kulture**. Este conjunto de alias y configuraciones está diseñado para optimizar el flujo de trabajo diario en la terminal, reduciendo la fricción y aplicando las mejores prácticas.

## 🚀 ¿Qué incluye este snippet?

1. 🛠️ **Setup Rápido de Git (`gitsets`)**: Un alias maestro para inyectar al instante tu identidad, credenciales SSH (usando `~/.ssh/github`), VS Code como editor por defecto y configuraciones de seguridad/higiene.
2. ⚡ **Shortcuts Diarios**: Alias de dos y tres letras para los comandos de Git más utilizados y para saltar entre los directorios clave de desarrollo al instante.
3. 📦 **Carga Modular**: Un inyector que carga automáticamente utilidades y scripts extraídos en `~/.bash_functions` para mantener el profile principal limpio.

## 💻 El Código (`~/.bashrc` / `~/.zshrc`)

Copia y pega el siguiente bloque directamente en tu archivo de configuración de terminal.

```bash
#:[.'.]:>- ===================================================================================
#:[.'.]:>- Marco Antonio - markitos devsecops kulture
#:[.'.]:>- The Way of the Artisan
#:[.'.]:>- markitos.es.info@gmail.com
#:[.'.]:>- 🌍 https://github.com/orgs/markitos-it/repositories
#:[.'.]:>- 🌍 https://github.com/orgs/markitos-public/repositories
#:[.'.]:>- 📺 https://www.youtube.com/@markitos_devsecops
#:[.'.]:>- ===================================================================================

#:[.'.]:>- Configuración personalizada de Git
alias gitsets='git config user.name "Marco Antonio - The Way of the Artisan" && \
git config user.email "markitos.es.info@gmail.com" && \
git config core.sshCommand "ssh -i ~/.ssh/github -o IdentitiesOnly=yes" && \
git config core.editor "code --wait" && \
git config init.defaultBranch main && \
git config push.default simple && \
git config credential.helper osxkeychain && \
git config pull.rebase false && \
git config core.filemode false'

#:[.'.]:>- Alias personalizados para Git y navegación
alias ggs="git status"
alias ggp="git pull"
alias ggcm="git commit -m "

alias ccdd="cd && cd development"
alias ccdg="cd && cd development/github/"
alias ccdr="cd && cd development/github/markitos-it/resources"

#:[.'.]:>- Cargar funciones bash personalizadas
if [ -f "$HOME/.bash_functions" ]; then
    . "$HOME/.bash_functions"
fi
```

> **Nota para el Artesano:** Una vez añadido a tu archivo, recuerda ejecutar `source ~/.bashrc` (o `source ~/.zshrc`) para que los cambios surtan efecto en tu terminal actual.

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