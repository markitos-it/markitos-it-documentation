terraform {
  backend "gcs" {
    bucket = "markitos-terraform-gke-states"
    prefix = "dev/markitos-es-mdk-infrastructure"
  }
}