# 🏗️ Infrastructure as Code: Terraform Modules

Welcome to the IaC (Infrastructure as Code) directory. This space contains standardized, reusable, and secure Terraform modules designed under **The Way of the Artisan** philosophy. 

These modules are not just configuration files; they are robust architectural pieces built with DevSecOps principles, ensuring immutability, least privilege, and deterministic deployments.

---

## 🧩 Module Structure

Each module in this directory follows a strict structural standard to ensure maintainability and clarity:

* `main.tf`: The core logic and resource definitions.
* `variables.tf`: Explicitly typed input variables with descriptions and validation rules.
* `outputs.tf`: Defined outputs for cross-module data sharing.
* `providers.tf`: Provider constraints, required versions, and remote state configurations.

---

## 🚀 Design Philosophy

1. **Immutability First:** Infrastructure should be replaced, not patched. Manual interventions (ClickOps) are strictly avoided.
2. **Secure by Default:** Secrets are never hardcoded. We integrate with Vault / Secret Managers for dynamic credential injection.
3. **State Management:** State files are strictly stored in encrypted remote backends with state locking enabled to prevent race conditions in CI/CD pipelines.

### Example Module Invocation

```hcl
module "artisanal_infrastructure" {
  source = "./modules/core-infrastructure"

  environment = "production"
  project_id  = var.gcp_project_id
  region      = "europe-southwest1"
}
```

---

## 🛠️ Prerequisites

* **Terraform** >= 1.5.0 (Managed locally via `tfenv`).
* Authenticated Cloud Provider CLI (e.g., `gcloud`) with appropriate IAM roles to perform the plan and apply stages.

---

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