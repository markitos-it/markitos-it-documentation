resource "google_service_account" "gke_nodepool_sa" {
  description  = "Service Account for GKE Autopilot Node Pool in ${var.environment} environment"
  display_name = "GKE Autopilot Node SA for ${var.environment}"
  project      = var.project_id
  account_id   = "${local.prefix}-gkenodepool-sa"
}

resource "google_project_iam_member" "gke_nodepool_sa_artifact_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gke_nodepool_sa.email}"
}

resource "google_service_account_iam_member" "gke_nodepool_terraform_sa_user" {
  service_account_id = google_service_account.gke_nodepool_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${local.terraform_service_account_email}"
}
