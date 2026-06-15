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
* <details open><summary>📁 **bash/**</summary>

  * <details><summary>📁 **howtos/**</summary>

    * 📄 [localhost-development-boostrap.md](./bash/howtos/localhost-development-boostrap.md)

    </details>
  * <details><summary>📁 **snippets/**</summary>

    * 📄 [bashrc-git-sets.md](./bash/snippets/bashrc-git-sets.md)
    * 📄 [install-github-ssh-key.md](./bash/snippets/install-github-ssh-key.md)
    * 📄 [ubuntu-25-system-cleaner.md](./bash/snippets/ubuntu-25-system-cleaner.md)

    </details>

  </details>
* <details open><summary>📁 **development/**</summary>

  * <details><summary>📁 **go/**</summary>

    * 📄 [install-grpc-tools.md](./development/go/install-grpc-tools.md)

    </details>
  * <details><summary>📁 **iac/**</summary>

    * <details><summary>📁 **terraform/**</summary>

      * <details><summary>📁 **snippets/**</summary>

        * 📄 [terraform-docs-updater.md](./development/iac/terraform/snippets/terraform-docs-updater.md)

        </details>

      </details>

    </details>

  </details>
* <details open><summary>📁 **docker/**</summary>

  * <details><summary>📁 **snippets/**</summary>

    * 📄 [docker-exec-multidatabases.md](./docker/snippets/docker-exec-multidatabases.md)

    </details>

  </details>
* <details open><summary>📁 **gcp/**</summary>

  * <details><summary>📁 **cloudbuild/**</summary>

    * 📄 [hello-go.md](./gcp/cloudbuild/hello-go.md)
    * 📄 [security-pipeline.md](./gcp/cloudbuild/security-pipeline.md)

    </details>
  * <details><summary>📁 **security/**</summary>

    * <details><summary>📁 **snippets/**</summary>

      * 📄 [create-secret-for-pull-github-from-gcp.md](./gcp/security/snippets/create-secret-for-pull-github-from-gcp.md)

      </details>

    </details>
  * <details><summary>📁 **terraform/**</summary>

    * <details><summary>📁 **000-assets/**</summary>

      * 📄 [make-module.sh](./gcp/terraform/000-assets/make-module.sh)

      </details>
    * <details><summary>📁 **001-welcome/**</summary>

      * 📄 [Makefile](./gcp/terraform/001-welcome/Makefile)
      * 📄 [main.tf](./gcp/terraform/001-welcome/main.tf)
      * 📄 [outputs.tf](./gcp/terraform/001-welcome/outputs.tf)
      * 📄 [providers.tf](./gcp/terraform/001-welcome/providers.tf)
      * 📄 [variables.tf](./gcp/terraform/001-welcome/variables.tf)

      </details>
    * <details><summary>📁 **002-gcp-bucket/**</summary>

      * 📄 [Makefile](./gcp/terraform/002-gcp-bucket/Makefile)
      * 📄 [bucket.tf](./gcp/terraform/002-gcp-bucket/bucket.tf)
      * 📄 [helpers.tf](./gcp/terraform/002-gcp-bucket/helpers.tf)
      * 📄 [outputs.tf](./gcp/terraform/002-gcp-bucket/outputs.tf)
      * 📄 [providers.tf](./gcp/terraform/002-gcp-bucket/providers.tf)
      * 📄 [variables.tf](./gcp/terraform/002-gcp-bucket/variables.tf)

      </details>
    * <details><summary>📁 **003-gcp-vpc/**</summary>

      * 📄 [Makefile](./gcp/terraform/003-gcp-vpc/Makefile)
      * 📄 [main.tf](./gcp/terraform/003-gcp-vpc/main.tf)
      * 📄 [outputs.tf](./gcp/terraform/003-gcp-vpc/outputs.tf)
      * 📄 [providers.tf](./gcp/terraform/003-gcp-vpc/providers.tf)
      * 📄 [variables.tf](./gcp/terraform/003-gcp-vpc/variables.tf)

      </details>
    * <details><summary>📁 **004-gke-standar-private-nodes-public-endpoint/**</summary>

      * 📄 [Makefile](./gcp/terraform/004-gke-standar-private-nodes-public-endpoint/Makefile)
      * 📄 [datas.tf](./gcp/terraform/004-gke-standar-private-nodes-public-endpoint/datas.tf)
      * 📄 [gke.tf](./gcp/terraform/004-gke-standar-private-nodes-public-endpoint/gke.tf)
      * 📄 [locals.tf](./gcp/terraform/004-gke-standar-private-nodes-public-endpoint/locals.tf)
      * 📄 [network.tf](./gcp/terraform/004-gke-standar-private-nodes-public-endpoint/network.tf)
      * 📄 [outputs.tf](./gcp/terraform/004-gke-standar-private-nodes-public-endpoint/outputs.tf)
      * 📄 [variables.tf](./gcp/terraform/004-gke-standar-private-nodes-public-endpoint/variables.tf)
      * 📄 [versions.tf](./gcp/terraform/004-gke-standar-private-nodes-public-endpoint/versions.tf)

      </details>
    * <details><summary>📁 **005-gke-standar-private-nodes-private-endpoint-bastion-access/**</summary>

      * 📄 [Makefile](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/Makefile)
      * 📄 [backend.tf](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/backend.tf)
      * 📄 [bastion.tf](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/bastion.tf)
      * 📄 [datas.tf](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/datas.tf)
      * 📄 [firewall.tf](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/firewall.tf)
      * <details><summary>📁 **gcloud-role-permissions-sa/**</summary>

        * 📄 [terraform-custom-role-permissions.list](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/gcloud-role-permissions-sa/terraform-custom-role-permissions.list)
        * 📄 [terraform-custom-role-permissions.sh](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/gcloud-role-permissions-sa/terraform-custom-role-permissions.sh)

        </details>
      * 📄 [gke.tf](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/gke.tf)
      * <details><summary>📁 **k8s-app-demo/**</summary>

        * 📄 [Makefile](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/k8s-app-demo/Makefile)
        * <details><summary>📁 **backend/**</summary>

          * 📄 [Dockerfile](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/k8s-app-demo/backend/Dockerfile)
          * <details><summary>📁 **cmd/**</summary>

            * 📄 [main.go](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/k8s-app-demo/backend/cmd/main.go)

            </details>
          * 📄 [go.mod](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/k8s-app-demo/backend/go.mod)
          * 📄 [go.sum](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/k8s-app-demo/backend/go.sum)

          </details>
        * 📄 [docker-compose.yaml](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/k8s-app-demo/docker-compose.yaml)
        * <details><summary>📁 **frontend/**</summary>

          * 📄 [Dockerfile](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/k8s-app-demo/frontend/Dockerfile)
          * <details><summary>📁 **cmd/**</summary>

            * 📄 [main.go](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/k8s-app-demo/frontend/cmd/main.go)

            </details>
          * 📄 [go.mod](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/k8s-app-demo/frontend/go.mod)

          </details>
        * <details><summary>📁 **manifests/**</summary>

          * 📄 [backend-deployment.yaml](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/k8s-app-demo/manifests/backend-deployment.yaml)
          * 📄 [frontend-deployment.yaml](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/k8s-app-demo/manifests/frontend-deployment.yaml)
          * 📄 [postgres-deployment.yaml](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/k8s-app-demo/manifests/postgres-deployment.yaml)

          </details>

        </details>
      * 📄 [locals.tf](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/locals.tf)
      * 📄 [main.tf](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/main.tf)
      * 📄 [nat-router.tf](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/nat-router.tf)
      * 📄 [network.tf](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/network.tf)
      * 📄 [outputs.tf](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/outputs.tf)
      * 📄 [variables.tf](./gcp/terraform/005-gke-standar-private-nodes-private-endpoint-bastion-access/variables.tf)

      </details>
    * <details><summary>📁 **006-gke-autopilot-public-endpoint/**</summary>

      * 📄 [Makefile](./gcp/terraform/006-gke-autopilot-public-endpoint/Makefile)
      * 📄 [backend.tf](./gcp/terraform/006-gke-autopilot-public-endpoint/backend.tf)
      * <details><summary>📁 **bin/**</summary>

        * <details><summary>📁 **makefile/**</summary>

          * <details><summary>📁 **gcloud/**</summary>

            * 📄 [install.sh](./gcp/terraform/006-gke-autopilot-public-endpoint/bin/makefile/gcloud/install.sh)

            </details>
          * <details><summary>📁 **iam-sa/**</summary>

            * 📄 [terraform-custom-role-permissions.list](./gcp/terraform/006-gke-autopilot-public-endpoint/bin/makefile/iam-sa/terraform-custom-role-permissions.list)
            * 📄 [terraform-custom-role-permissions.sh](./gcp/terraform/006-gke-autopilot-public-endpoint/bin/makefile/iam-sa/terraform-custom-role-permissions.sh)

            </details>

          </details>

        </details>
      * 📄 [datas.tf](./gcp/terraform/006-gke-autopilot-public-endpoint/datas.tf)
      * 📄 [gke.tf](./gcp/terraform/006-gke-autopilot-public-endpoint/gke.tf)
      * 📄 [iam.tf](./gcp/terraform/006-gke-autopilot-public-endpoint/iam.tf)
      * <details><summary>📁 **k8s-app-demo/**</summary>

        * 📄 [Makefile](./gcp/terraform/006-gke-autopilot-public-endpoint/k8s-app-demo/Makefile)
        * <details><summary>📁 **backend/**</summary>

          * 📄 [Dockerfile](./gcp/terraform/006-gke-autopilot-public-endpoint/k8s-app-demo/backend/Dockerfile)
          * <details><summary>📁 **cmd/**</summary>

            * 📄 [main.go](./gcp/terraform/006-gke-autopilot-public-endpoint/k8s-app-demo/backend/cmd/main.go)

            </details>
          * 📄 [go.mod](./gcp/terraform/006-gke-autopilot-public-endpoint/k8s-app-demo/backend/go.mod)
          * 📄 [go.sum](./gcp/terraform/006-gke-autopilot-public-endpoint/k8s-app-demo/backend/go.sum)

          </details>
        * 📄 [docker-compose.yaml](./gcp/terraform/006-gke-autopilot-public-endpoint/k8s-app-demo/docker-compose.yaml)
        * <details><summary>📁 **frontend/**</summary>

          * 📄 [Dockerfile](./gcp/terraform/006-gke-autopilot-public-endpoint/k8s-app-demo/frontend/Dockerfile)
          * <details><summary>📁 **cmd/**</summary>

            * 📄 [main.go](./gcp/terraform/006-gke-autopilot-public-endpoint/k8s-app-demo/frontend/cmd/main.go)

            </details>
          * 📄 [go.mod](./gcp/terraform/006-gke-autopilot-public-endpoint/k8s-app-demo/frontend/go.mod)

          </details>
        * <details><summary>📁 **manifests/**</summary>

          * 📄 [backend-deployment.yaml](./gcp/terraform/006-gke-autopilot-public-endpoint/k8s-app-demo/manifests/backend-deployment.yaml)
          * 📄 [frontend-deployment.yaml](./gcp/terraform/006-gke-autopilot-public-endpoint/k8s-app-demo/manifests/frontend-deployment.yaml)
          * 📄 [postgres-deployment.yaml](./gcp/terraform/006-gke-autopilot-public-endpoint/k8s-app-demo/manifests/postgres-deployment.yaml)

          </details>

        </details>
      * 📄 [locals.tf](./gcp/terraform/006-gke-autopilot-public-endpoint/locals.tf)
      * 📄 [nat-router.tf](./gcp/terraform/006-gke-autopilot-public-endpoint/nat-router.tf)
      * 📄 [network.tf](./gcp/terraform/006-gke-autopilot-public-endpoint/network.tf)
      * 📄 [outputs.tf](./gcp/terraform/006-gke-autopilot-public-endpoint/outputs.tf)
      * 📄 [providers.tf](./gcp/terraform/006-gke-autopilot-public-endpoint/providers.tf)
      * 📄 [variables.tf](./gcp/terraform/006-gke-autopilot-public-endpoint/variables.tf)
      * 📄 [versions.tf](./gcp/terraform/006-gke-autopilot-public-endpoint/versions.tf)

      </details>
    * 📄 [LICENSE](./gcp/terraform/LICENSE)

    </details>

  </details>
* <details open><summary>📁 **github/**</summary>

  * <details><summary>📁 **actions/**</summary>

    * <details><summary>📁 **action/**</summary>

      * <details><summary>📁 **hello-go-action/**</summary>

        * 📄 [action.go](./github/actions/action/hello-go-action/action.go)
        * 📄 [action.yaml](./github/actions/action/hello-go-action/action.yaml)
        * 📄 [hello-workflow.yaml](./github/actions/action/hello-go-action/hello-workflow.yaml)

        </details>

      </details>
    * <details><summary>📁 **workflows/**</summary>

      * 📄 [makefile-docker-postgres-appsec.md](./github/actions/workflows/makefile-docker-postgres-appsec.md)

      </details>

    </details>

  </details>
* <details open><summary>📁 **kubernetes/**</summary>

  * 📄 [kubeadm-ha.md](./kubernetes/kubeadm-ha.md)
  * <details><summary>📁 **microk8s/**</summary>

    * 📄 [external-secrets.md](./kubernetes/microk8s/external-secrets.md)

    </details>
  * <details><summary>📁 **snippets/**</summary>

    * 📄 [kubernetes-multidatabases.md](./kubernetes/snippets/kubernetes-multidatabases.md)
    * 📄 [microk8s-external-secrets-create.md](./kubernetes/snippets/microk8s-external-secrets-create.md)

    </details>

  </details>
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