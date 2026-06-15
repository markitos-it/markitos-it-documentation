terraform {
  backend "gcs" {
    bucket = "markitos-it-portfolio-tfstates"
    prefix = "001-vpc/state"
  }
}