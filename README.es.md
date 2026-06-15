# 🏛️ The Artisan's Knowledge Base

*Read this in [English](README.md).*


Bienvenido a mi repositorio público de documentación centralizada. Este espacio funciona como una bitácora técnica, un compendio de conocimiento y una fuente única de la verdad donde organizo guías, soluciones a problemas reales y flujos de arquitectura bajo la filosofía de **The Way of the Artisan** (El Camino del Artesano).

Aquí no encontrarás scripts rápidos "copiar y pegar" sin contexto; cada entrada está estructurada para entender el *porqué* de las cosas, priorizando la robustez, la seguridad y la elegancia técnica.

---

## 🛠️ Temáticas Principales

La documentación cubre de manera transversal el ecosistema moderno de infraestructura y desarrollo:

* **Cloud Native & Kubernetes:** MicroK8s, patrones de diseño de Pods, operadores (ESO), Service Mesh y RBAC.
* **DevSecOps & SRE:** Gestión de secretos (Vault), auditoría de código/secretos (Snyk, Gitleaks), CI/CD y automatización.
* **Infrastructure as Code (IaC):** Módulos de Terraform estandarizados y lógica modular.
* **Backend & Architecture:** Lógica artesanal en Go (Golang), microservicios con gRPC y optimización de servicios.
* **Linux & Home Lab:** Gestión de entornos locales (Intel NUC, tmux, k9s, redes internas) y tuning del sistema.

---

## 📂 Índice de Contenidos

<!-- INDEX_START -->
* 📄 [LICENSE](./LICENSE)
* 📄 [Makefile](./Makefile)
* 📁 **bash/**
  * 📁 **howtos/**
    * 📄 [localhost-development-boostrap.md](./bash/howtos/localhost-development-boostrap.md)
  * 📁 **snippets/**
    * 📄 [bashrc-git-sets.md](./bash/snippets/bashrc-git-sets.md)
    * 📄 [install-github-ssh-key.md](./bash/snippets/install-github-ssh-key.md)
    * 📄 [ubuntu-25-system-cleaner.md](./bash/snippets/ubuntu-25-system-cleaner.md)
* 📁 **development/**
  * 📁 **go/**
    * 📄 [install-grpc-tools.md](./development/go/install-grpc-tools.md)
  * 📁 **iac/**
    * 📁 **terraform/**
      * 📁 **snippets/**
        * 📄 [terraform-docs-updater.md](./development/iac/terraform/snippets/terraform-docs-updater.md)
* 📁 **docker/**
  * 📁 **snippets/**
    * 📄 [docker-exec-multidatabases.md](./docker/snippets/docker-exec-multidatabases.md)
* 📁 **gcp/**
  * 📁 **cloudbuild/**
    * 📄 [security-pipeline.md](./gcp/cloudbuild/security-pipeline.md)
  * 📁 **security/**
    * 📁 **snippets/**
      * 📄 [create-secret-for-pull-github-from-gcp.md](./gcp/security/snippets/create-secret-for-pull-github-from-gcp.md)
  * 📁 **terraform/**
    * 📁 **000-backend/**
      * 📄 [Makefile](./gcp/terraform/000-backend/Makefile)
      * 📄 [backend.tf](./gcp/terraform/000-backend/backend.tf)
      * 📄 [main.tf](./gcp/terraform/000-backend/main.tf)
      * 📄 [outputs.tf](./gcp/terraform/000-backend/outputs.tf)
      * 📄 [providers.tf](./gcp/terraform/000-backend/providers.tf)
      * 📄 [variables.tf](./gcp/terraform/000-backend/variables.tf)
    * 📁 **001-vpc/**
      * 📄 [Makefile](./gcp/terraform/001-vpc/Makefile)
      * 📄 [backend.tf](./gcp/terraform/001-vpc/backend.tf)
      * 📄 [main.tf](./gcp/terraform/001-vpc/main.tf)
      * 📄 [outputs.tf](./gcp/terraform/001-vpc/outputs.tf)
      * 📄 [providers.tf](./gcp/terraform/001-vpc/providers.tf)
      * 📄 [variables.tf](./gcp/terraform/001-vpc/variables.tf)
    * 📁 **002-gke/**
      * 📄 [Makefile](./gcp/terraform/002-gke/Makefile)
      * 📄 [backend.tf](./gcp/terraform/002-gke/backend.tf)
      * 📄 [main.tf](./gcp/terraform/002-gke/main.tf)
      * 📄 [outputs.tf](./gcp/terraform/002-gke/outputs.tf)
      * 📄 [providers.tf](./gcp/terraform/002-gke/providers.tf)
      * 📄 [variables.tf](./gcp/terraform/002-gke/variables.tf)
    * 📄 [docs-updater.sh](./gcp/terraform/docs-updater.sh)
* 📁 **kubernetes/**
  * 📁 **microk8s/**
    * 📄 [external-secrets.md](./kubernetes/microk8s/external-secrets.md)
  * 📁 **snippets/**
    * 📄 [kubernetes-multidatabases.md](./kubernetes/snippets/kubernetes-multidatabases.md)
    * 📄 [microk8s-external-secrets-create.md](./kubernetes/snippets/microk8s-external-secrets-create.md)
* 📄 [links-readmes.go](./links-readmes.go)
<!-- INDEX_END -->

---

## 🤝 Contribuciones y Feedback

Este repositorio es abierto y público. Si encuentras una errata, un comando desactualizado o crees que un flujo se puede optimizar para ser más artesanal, siéntete libre de abrir un **Issue** o enviar un **Pull Request**. La cultura DevSecOps se basa en la mejora continua compartida.

---

```markdown
#:[.'.]:>- ===================================================================================
#:[.'.]:>- Marco Antonio - markitos devsecops kulture
#:[.'.]:>- The Way of the Artisan
#:[.'.]:>- markitos.es.info@gmail.com
#:[.'.]:>- 🌍 [https://github.com/orgs/markitos-it/repositories](https://github.com/orgs/markitos-it/repositories)
#:[.'.]:>- 🌍 [https://github.com/orgs/markitos-public/repositories](https://github.com/orgs/markitos-public/repositories)
#:[.'.]:>- 📺 [https://www.youtube.com/@markitos_devsecops](https://www.youtube.com/@markitos_devsecops)
#:[.'.]:>- ===================================================================================
```