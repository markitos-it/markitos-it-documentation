output "prefix" {
  description = "The prefix used for naming resources in the dev environment."
  value       = local.prefix
}

output "gke_service_account_email" {
  description = "The email of the GKE service account."
  value       = google_service_account.gke_nodepool_sa.email
}

output "gke_cluster_name" {
  description = "The name of the GKE cluster."
  value       = google_container_cluster.gke_cluster.name
}

output "gke_cluster_location" {
  description = "The location of the GKE cluster."
  value       = google_container_cluster.gke_cluster.location
}

output "gke_cluster_endpoint" {
  description = "The endpoint of the GKE cluster."
  value       = google_container_cluster.gke_cluster.endpoint
}

output "gke_cluster_master_version" {
  description = "The master version of the GKE cluster."
  value       = google_container_cluster.gke_cluster.master_version
}

output "gke_available_zones" {
  description = "values of available zones in the project"
  value       = data.google_compute_zones.available_zones.names
}
