# 🏛️ The Artisan's Knowledge Base

*Read this in [Spanish](README.es.md).*

Welcome to my public centralized documentation repository. This space serves as a technical logbook, a compendium of knowledge, and a single source of truth where I organize guides, solutions to real-world problems, and architectural flows under the philosophy of **The Way of the Artisan**.

Here you won't find quick "copy and paste" scripts without context; each entry is structured to help you understand the *why* of things, prioritizing robustness, security, and technical elegance.

---

## 📂 Índice de Contenidos

<!-- INDEX_START -->
* 📄 [LICENSE](./LICENSE)
* 📄 [Makefile](./Makefile)
* 📁 **appsec/**
* 📁 **bash/**
  * 📁 **howtos/**
    * 📄 [localhost-development-boostrap.md](./bash/howtos/localhost-development-boostrap.md)
  * 📁 **snippets/**
    * 📄 [bashrc-git-sets.md](./bash/snippets/bashrc-git-sets.md)
    * 📄 [install-github-ssh-key.md](./bash/snippets/install-github-ssh-key.md)
    * 📄 [terraform-docs-updater.md](./bash/snippets/terraform-docs-updater.md)
    * 📄 [ubuntu-25-system-cleaner.md](./bash/snippets/ubuntu-25-system-cleaner.md)
* 📁 **development/**
  * 📁 **go/**
    * 📄 [install-grpc-tools.md](./development/go/install-grpc-tools.md)
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

## 🛠️ Main Topics

The documentation transversally covers the modern infrastructure and development ecosystem:

* **Cloud Native & Kubernetes:** MicroK8s, Pod design patterns, operators (ESO), Service Mesh, and RBAC.
* **DevSecOps & SRE:** Secrets management (Vault), code/secrets auditing (Snyk, Gitleaks), CI/CD, and automation.
* **Infrastructure as Code (IaC):** Standardized Terraform modules and modular logic.
* **Backend & Architecture:** Artisanal logic in Go (Golang), microservices with gRPC, and service optimization.
* **Linux & Home Lab:** Management of local environments (Intel NUC, tmux, k9s, internal networks) and system tuning.

---

## 🤝 Contributions and Feedback

This repository is open and public. If you find a typo, an outdated command, or believe a flow can be optimized to be more artisanal, feel free to open an **Issue** or submit a **Pull Request**. The DevSecOps culture is based on shared continuous improvement.

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