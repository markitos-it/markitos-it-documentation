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

variable "bucket_name" {
  description = "Nombre del bucket para el estado de Terraform"
  type        = string
  default     = "markitos-it-portfolio-tfstates"
}
