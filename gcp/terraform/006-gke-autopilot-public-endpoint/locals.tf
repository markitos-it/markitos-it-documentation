locals {
  prefix                          = "${var.project}-${var.environment}-${var.team}"
  service_account_path            = "${path.module}/../.nogit/terraform-markitos-es-mdk-sa-markitos-mdk-labs.json"
  network_ssh_tags                = [for tag in var.network_ssh_tags : "${local.prefix}-${tag}"]
  deletion_cluster_protection     = var.environment == "prod" ? true : false
  cluster_node_locations          = [for z in data.google_compute_zones.available_zones.names : z if z != data.google_compute_zones.available_zones.names[0]]
  terraform_service_account_email = "${var.terraform_gcp_service_account_name}@${var.project_id}.iam.gserviceaccount.com"

  common_tags = [
    var.project,
    var.project_id,
    var.environment,
    var.team
  ]
}
