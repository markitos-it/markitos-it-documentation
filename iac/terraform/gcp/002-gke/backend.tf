terraform {
  backend "gcs" {
    bucket = "markitos-it-portfolio-tfstates"
    prefix = "002-gke/state"
  }
}
