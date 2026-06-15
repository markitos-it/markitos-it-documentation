#:[.'.]:>- --------------------------------------------------
#:[.'.]:>- GCP Variables for Terraform Configuration
#:[.'.]:>- --------------------------------------------------
variable "terraform_gcp_service_account_name" {
  description = "The service account for use ONLY with terraform. Dont use for GKE cluster creation, GKE use another service account"
  type        = string
  default     = "terraform-markitos-es-mdk-sa"
}


variable "region" {
  description = "The GCP region where the resources will be deployed."
  type        = string
  default     = "us-central1"
}

variable "project_id" {
  description = "The GCP project ID where the resources will be created."
  type        = string
  default     = "markitos-mdk-labs"
}

variable "project" {
  description = "The name of the project for compose prefix and others resources."
  type        = string
  default     = "mdk"
}

variable "environment" {
  description = "The environment for which the resources are being created (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "team" {
  description = "The team responsible for the resources."
  type        = string
  default     = "devops"
}
#:[.'.]:>- --------------------------------------------------


#:[.'.]:>- --------------------------------------------------
#:[.'.]:>- Network Variables
#:[.'.]:>- --------------------------------------------------
variable "network_ssh_tags" {
  description = "List of tags to apply to the sshed hosts resources."
  type        = list(string)
  default     = ["ssh-host"]
}

variable "firewall_ports" {
  description = "List of ports to allow in the firewall rules."
  type        = list(string)
  default     = ["22"]
}
#:[.'.]:>- --------------------------------------------------


#:[.'.]:>- --------------------------------------------------
#:[.'.]:>- GKE Private Cluster Variables
#:[.'.]:>- --------------------------------------------------
variable "subnet_ip_range" {
  description = "The IP range for the subnet in CIDR notation."
  type        = string
  default     = "10.10.0.0/16"
}

variable "pods_ip_range" {
  description = "The IP range for the pods in CIDR notation."
  type        = string
  default     = "10.1.0.0/21"
}

variable "services_ip_range" {
  description = "The IP range for the services in CIDR notation."
  type        = string
  default     = "10.2.0.0/21"
}

variable "master_ip_range" {
  description = "The IP range for the master in CIDR notation."
  type        = string
  default     = "10.3.0.0/28"
}
#:[.'.]:>- --------------------------------------------------
