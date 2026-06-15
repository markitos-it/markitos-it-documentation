resource "google_project_service" "container_api" {
  service            = "container.googleapis.com"
  project            = var.project_id
  disable_on_destroy = false
}

resource "google_container_cluster" "autopilot_cluster" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  enable_autopilot = true

  network    = "projects/${var.project_id}/global/networks/${var.vpc_name}"
  subnetwork = "projects/${var.project_id}/regions/${var.region}/subnetworks/${var.subnet_name}"

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  ip_allocation_policy {}
  deletion_protection = false

  depends_on = [google_project_service.container_api]

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}
