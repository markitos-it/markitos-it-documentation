variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
  default     = "markitosit-labs"
}

variable "region" {
  description = "Región de GCP"
  type        = string
  default     = "europe-southwest1"
}

variable "vpc_name" {
  description = "Nombre de la VPC"
  type        = string
  default     = "markitos-it-labs-vpc"
}

variable "subnet_name" {
  description = "The name of the subnetwork"
  type        = string
  default     = "markitos-it-vpc-subnet"
}

variable "cluster_name" {
  description = "The name of the GKE Autopilot cluster"
  type        = string
  default     = "markitos-it-cluster"
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation to use for the hosted master network. Must be a /28 subnet."
  type        = string
  default     = "172.16.0.0/28"
}
