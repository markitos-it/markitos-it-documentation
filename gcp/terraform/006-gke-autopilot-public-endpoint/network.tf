resource "google_compute_network" "vpc_network" {
  name                    = "${local.prefix}-vpc"
  description             = "VPC network for the ${var.environment} environment managed by ${var.team} team"
  project                 = var.project_id
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name                     = "${local.prefix}-${var.region}-subnet"
  description              = "Subnetwork ${var.environment} environment managed by ${var.team} team on region location: ${var.region}"
  region                   = var.region
  project                  = var.project_id
  network                  = google_compute_network.vpc_network.id
  ip_cidr_range            = var.subnet_ip_range
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "kubernetes-pods-range"
    ip_cidr_range = var.pods_ip_range
  }

  secondary_ip_range {
    range_name    = "kubernetes-services-range"
    ip_cidr_range = var.services_ip_range
  }

  depends_on = [google_compute_network.vpc_network]
}


output "vpc_id" {
  value = google_compute_network.vpc_network.id
}

output "subnet_id" {
  value = google_compute_subnetwork.subnet.id
}

output "subnet_ip_range" {
  value = google_compute_subnetwork.subnet.ip_cidr_range
}

output "vpc_self_link" {
  value = google_compute_network.vpc_network.self_link
}

output "subnet_self_link" {
  value = google_compute_subnetwork.subnet.self_link
}
