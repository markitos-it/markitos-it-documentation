output "bucket_name" {
  description = "Nombre del bucket creado para el estado de Terraform"
  value       = google_storage_bucket.terraform_state.name
}

output "bucket_url" {
  description = "URL del bucket"
  value       = google_storage_bucket.terraform_state.url
}