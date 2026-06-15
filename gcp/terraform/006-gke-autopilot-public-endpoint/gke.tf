resource "google_container_cluster" "gke_cluster" {
  name                = "${local.prefix}-gke-cluster"
  description         = "GKE Autopilot cluster located at ${var.region} for the ${var.environment} environment managed by ${var.team} team"
  location            = var.region
  project             = var.project_id
  network             = google_compute_network.vpc_network.self_link
  subnetwork          = google_compute_subnetwork.subnet.self_link
  enable_autopilot    = true
  deletion_protection = local.deletion_cluster_protection

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ip_range
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = local.prefix
    }
  }

  node_config {
    service_account = google_service_account.gke_nodepool_sa.email
    oauth_scopes = [
      # Scopes más restrictivos para seguir el principio de mínimo privilegio
      # only this one: https://www.googleapis.com/auth/cloud-platform  or:
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }


  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.subnet.secondary_ip_range[0].range_name
    services_secondary_range_name = google_compute_subnetwork.subnet.secondary_ip_range[1].range_name
  }

  depends_on = [
    google_service_account_iam_member.gke_nodepool_terraform_sa_user
  ]
}
