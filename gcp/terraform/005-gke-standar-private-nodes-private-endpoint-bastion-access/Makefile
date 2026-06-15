GOOGLE_APPLICATION_CREDENTIALS :=../.nogit/mdk-terraform-sa-markitos-mdk-gke.json

init:
	@GOOGLE_APPLICATION_CREDENTIALS="$(GOOGLE_APPLICATION_CREDENTIALS)" terraform init

plan:
	@GOOGLE_APPLICATION_CREDENTIALS="$(GOOGLE_APPLICATION_CREDENTIALS)" terraform plan

apply:
	@GOOGLE_APPLICATION_CREDENTIALS="$(GOOGLE_APPLICATION_CREDENTIALS)" terraform apply -auto-approve

destroy:
	@GOOGLE_APPLICATION_CREDENTIALS="$(GOOGLE_APPLICATION_CREDENTIALS)" terraform destroy -auto-approve

validate:
	@GOOGLE_APPLICATION_CREDENTIALS="$(GOOGLE_APPLICATION_CREDENTIALS)" terraform validate

list:
	@GOOGLE_APPLICATION_CREDENTIALS="$(GOOGLE_APPLICATION_CREDENTIALS)" terraform state list

show:
	@GOOGLE_APPLICATION_CREDENTIALS="$(GOOGLE_APPLICATION_CREDENTIALS)" terraform state show ${uri}

clean:
	rm -rf .terraform*
	rm -f terraform.tfstate*

install-terraform:
	echo "Instalando Terraform 1.12.2 en ~/.local/bin ..."
	mkdir -p ~/.local/bin
	wget https://releases.hashicorp.com/terraform/1.12.2/terraform_1.12.2_linux_amd64.zip -O /tmp/terraform.zip
	unzip -o /tmp/terraform.zip -d ~/.local/bin
	chmod +x ~/.local/bin/terraform
	rm /tmp/terraform.zip
	echo "Terraform instalado correctamente en ~/.local/bin"
	echo 'export PATH=$$PATH:$$HOME/.local/bin' >> $$HOME/.bashrc

gpc-sets:
	gcloud config set project ${project}

remove-extra-iam-permissions:
	@echo "Removing project-level 'Artifact Registry Reader' role from mdk-terraform-sa..."
	@gcloud projects remove-iam-policy-binding markitos-mdk-gke \
		--member="serviceAccount:mdk-terraform-sa@markitos-mdk-gke.iam.gserviceaccount.com" \
		--role="roles/artifactregistry.reader" --condition=None || true
	@echo "Removing project-level 'Service Account User' role from mdk-terraform-sa..."
	@gcloud projects remove-iam-policy-binding markitos-mdk-gke \
		--member="serviceAccount:mdk-terraform-sa@markitos-mdk-gke.iam.gserviceaccount.com" \
		--role="roles/iam.serviceAccountUser" --condition=None || true
