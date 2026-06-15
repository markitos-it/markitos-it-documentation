# 🚀 Terraform GCP Boilerplate - Hello World

> **"El camino del artesano"** - Marco Antonio (markitos) - DevsecopsKulture

---

## 🎯 **¿Qué es esto?**

Un boilerplate **súper simple** y **agnóstico** para Terraform + GCP que te permite empezar rápidamente con las mejores prácticas sin complicaciones.

### **Filosofía del proyecto:**
- ✅ **Simplicidad máxima** - Sin tfvars innecesarios
- ✅ **Naming semántico** - Variables descriptivas y consistentes  
- ✅ **Defaults inteligentes** - Solo requiere lo esencial
- ✅ **Validaciones robustas** - Previene errores comunes
- ✅ **Tags estandarizados** - Consistencia en todos los recursos

---

## 🏗️ **Estructura del proyecto**

```
template/
├── variables.tf    # Variables con defaults y validaciones
├── providers.tf    # Configuración de providers GCP
├── main.tf         # Recurso hello world con tags
├── outputs.tf      # Outputs útiles y documentados
├── Makefile        # Comandos útiles (existente)
├── dot.gitignore   # Archivo .gitignore (renombrar quitando 'dot')
├── key.json        # Credenciales GCP (crear aquí - NO subir a git)
└── README.md       # Este archivo
```

---

## 🔐 **Configuración inicial**

### **1. Configurar credenciales**
```bash
# Coloca tu archivo de credenciales GCP en el root del proyecto
cp /path/to/your/service-account.json ./key.json
```

### **2. Configurar gitignore**
```bash
# Renombra el archivo quitando 'dot' para activarlo
mv dot.gitignore .gitignore
```

### **3. Verificar que key.json está ignorado**
```bash
git status  # key.json NO debe aparecer
```

---

## 🛠️ **Variables**

### **⚡ Requeridas (sin default)**
```bash
# Environment target - obligatorio
TF_VAR_environment_target=dev|prod|pre|staging|qa

# Group category - obligatorio (solo letras a-z, 3-25 chars)
TF_VAR_group_category=networking
```

### **🔧 Con defaults configurados**
| Variable | Default | Descripción |
|----------|---------|-------------|
| `credentials_file_path` | `./key.json` | Ruta al archivo JSON de credenciales (root del proyecto) |
| `project_identifier` | `terraform-markitos` | ID del proyecto GCP |
| `deployment_region` | `us-central1` | Región de despliegue |
| `deployment_zone` | `us-central1-a` | Zona de disponibilidad |
| `resource_creator_information` | `Marco Antonio - markitos - DevsecopsKulture` | Información del creador |

---

## 🚀 **Uso rápido**

### **1. Configurar proyecto**
```bash
# Renombrar quitando 'dot' para activar gitignore
mv dot.gitignore .gitignore

# Colocar credenciales GCP en root
cp /path/to/your/service-account.json ./key.json
```

### **2. Inicializar Terraform**
```bash
terraform init
```

### **3. Planificar con variables requeridas**
```bash
TF_VAR_environment_target=dev TF_VAR_group_category=networking terraform plan
```

### **4. Aplicar cambios**
```bash
TF_VAR_environment_target=dev TF_VAR_group_category=networking terraform apply
```

### **4. Ver outputs**
```bash
terraform output
```

---

## 🏷️ **Tags estandarizados**

Todos los recursos se etiquetan automáticamente con:

```hcl
{
  environment = "dev"                                        # Tu environment_target
  creator     = "Marco Antonio - markitos - DevsecopsKulture" # Información del creador
  category    = "networking"                                 # Tu group_category
  managed_by  = "terraform"                                  # Gestión automática
  project     = "terraform-markitos"                        # ID del proyecto
}
```

---

## 🎯 **Ejemplos prácticos**

### **Para desarrollo local:**
```bash
TF_VAR_environment_target=dev TF_VAR_group_category=testing terraform plan
```

### **Para producción:**
```bash
TF_VAR_environment_target=prod TF_VAR_group_category=platform terraform apply
```

### **Para seguridad:**
```bash
TF_VAR_environment_target=prod TF_VAR_group_category=security terraform plan
```

---

## 🔍 **Validaciones incluidas**

- **Environment target:** Solo acepta `dev`, `prod`, `pre`, `staging`, `qa`
- **Group category:** Solo letras minúsculas (a-z), entre 3-25 caracteres
- **Prevención de errores:** Validación automática antes del despliegue

---

## 📋 **Outputs disponibles**

Al ejecutar `terraform output` obtienes:

```bash
deployment_region             = "us-central1"
environment_deployment_target = "dev"
group_category               = "networking"
project_identifier           = "terraform-markitos"
resource_creator_information = "Marco Antonio - markitos - DevsecopsKulture"
resource_unique_suffix       = "a1b2c3d4"
standardized_resource_tags   = {
  "category"    = "networking"
  "creator"     = "Marco Antonio - markitos - DevsecopsKulture"
  "environment" = "dev"
  "managed_by"  = "terraform"
  "project"     = "terraform-markitos"
}
```

---

## 🎨 **Mejores prácticas aplicadas**

### **✅ Seguridad incluida**
- Gitignore completo con mejores prácticas
- Credenciales protegidas automáticamente
- Archivos sensibles nunca en git
- Terraform state files ignorados

### **✅ Sin tfvars**
- Usa environment variables o defaults
- Menos archivos = menos complejidad
- Más fácil para CI/CD

### **✅ Naming consistente**
- Variables descriptivas y semánticas
- Sin prefijos innecesarios
- Fácil de entender y mantener

### **✅ Validaciones robustas**
- Previene errores comunes
- Feedback inmediato
- Código autovalidado

### **✅ Documentación completa**
- Todas las variables tienen descripción
- Ejemplos prácticos
- Casos de uso claros

---

## 🤝 **Contribuciones**

Este boilerplate sigue **"El camino del artesano"** - siempre buscando la excelencia técnica y la simplicidad elegante.

**Creado por:** Marco Antonio (markitos) - DevsecopsKulture

---

## 📚 **Extensiones futuras**

Este boilerplate es tu punto de partida. Puedes extenderlo con:

- 🔐 **Recursos de seguridad** (IAM, firewalls)
- 🌐 **Networking** (VPC, subnets, load balancers)  
- 💾 **Storage** (buckets, persistent disks)
- 📊 **Monitoring** (logging, metrics)
- 🔄 **CI/CD** (Cloud Build, triggers)

---

**¡Que disfrutes construyendo infraestructura como código! 🚀**

> *"La simplicidad es la máxima sofisticación"* - Leonardo da Vinci
