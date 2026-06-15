output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.autopilot_cluster.name
}

output "cluster_endpoint" {
  description = "The IP address of the cluster master"
  value       = google_container_cluster.autopilot_cluster.endpoint
  sensitive   = true
}

output "cluster_location" {
  description = "The location of the GKE cluster"
  value       = google_container_cluster.autopilot_cluster.location
}

output "cluster_ca_certificate" {
  description = "The base64 encoded public certificate of the cluster"
  value       = google_container_cluster.autopilot_cluster.master_auth[0].cluster_ca_certificate
  sensitive   = true
}
