output "vpc_id" {
  description = "ID de la VPC creada"
  value       = google_compute_network.vpc.id
}

output "vpc_name" {
  description = "Nombre de la VPC"
  value       = google_compute_network.vpc.name
}

output "subnet_id" {
  description = "ID de la subred"
  value       = google_compute_subnetwork.subnet.id
}

output "subnet_name" {
  description = "Nombre de la subred"
  value       = google_compute_subnetwork.subnet.name
}