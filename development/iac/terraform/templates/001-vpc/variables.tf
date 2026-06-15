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
  description = "Nombre de la subred"
  type        = string
  default     = "markitos-it-labs-vpc-subnet"
}

variable "subnet_cidr" {
  description = "CIDR de la subred"
  type        = string
  default     = "10.0.0.0/24"
}