#:[.'.]:>- ===================================================================================
#:[.'.]:>- Marco Antonio - markitos devsecops kulture
#:[.'.]:>- The Way of the Artisan
#:[.'.]:>- markitos.es.info@gmail.com
#:[.'.]:>- 🌍 https://github.com/orgs/markitos-it/repositories
#:[.'.]:>- 🌍 https://github.com/orgs/markitos-public/repositories
#:[.'.]:>- 📺 https://www.youtube.com/@markitos_devsecops
#:[.'.]:>- =================================================================================

.PHONY: help i init p plan a apply d destroy v validate o output aa dd c clean

# Default target
help:
	@echo "#:[.'.]:>- Terraform Makefile Commands"
	@echo "#:[.'.]:>- i/init   	: Initialize Terraform"
	@echo "#:[.'.]:>- p/plan   	: Plan Terraform changes"
	@echo "#:[.'.]:>- a/apply  	: Apply Terraform changes (with confirmation)"
	@echo "#:[.'.]:>- d/destroy	: Destroy Terraform resources (with confirmation)"
	@echo "#:[.'.]:>- v/validate: Validate Terraform configuration"
	@echo "#:[.'.]:>- o/output 	: Show Terraform outputs"
	@echo "#:[.'.]:>- aa       	: Apply with auto-approve"
	@echo "#:[.'.]:>- dd       	: Destroy with auto-approve"
	@echo "#:[.'.]:>- c/clean  	: Clean Terraform files (.terraform/, *.tfstate*)"
	@echo ""
	@echo "#:[.'.]:>- Required Environment Variables:"
	@echo "#:[.'.]:>- TF_VAR_project_id : GCP Project ID"
	@echo "#:[.'.]:>- TF_VAR_region     : GCP Region"
	@echo "#:[.'.]:>- TF_VAR_vpc_name   : VPC Name"
	@echo "#:[.'.]:>- TF_VAR_subnet_name: Subnet Name"
	@echo "#:[.'.]:>- TF_VAR_cluster_name: GKE Cluster Name"
	@echo "#:[.'.]:>- TF_VAR_master_ipv4_cidr_block: Master IPv4 CIDR Block (/28)"
	@echo "#:[.'.]:>- TF_VAR_bucket_name: GCS Backend Bucket Name"
	@echo ""
	@echo "#:[.'.]:>- Example Usage:"
	@echo "#:[.'.]:>- export TF_VAR_project_id=\"markitos-it-laboratories\""
	@echo "#:[.'.]:>- export TF_VAR_region=\"europe-southwest1\""
	@echo "#:[.'.]:>- export TF_VAR_vpc_name=\"markitos-it-vpc\""
	@echo "#:[.'.]:>- export TF_VAR_subnet_name=\"markitos-it-subnet1\""
	@echo "#:[.'.]:>- export TF_VAR_cluster_name=\"markitos-it-autopilot\""
	@echo "#:[.'.]:>- export TF_VAR_master_ipv4_cidr_block=\"172.16.0.0/28\""
	@echo "#:[.'.]:>- export TF_VAR_bucket_name=\"markitos-it-portfolio-tfstates\""
	@echo "#:[.'.]:>- make i && make p && make a"
	@echo ""
	@echo "#:[.'.]:>- 📄 Reference: See ../README.md for full configuration details and IAM roles."

i init:
	terraform init

p plan:
	terraform plan

a apply:
	terraform apply

d destroy:
	terraform destroy

v validate:
	terraform validate

o output:
	terraform output

aa:
	terraform apply -auto-approve

dd:
	terraform destroy -auto-approve

c clean:
	rm -rf .terraform/
	rm -f terraform.tfstate*
	rm -f .terraform.lock.hcl