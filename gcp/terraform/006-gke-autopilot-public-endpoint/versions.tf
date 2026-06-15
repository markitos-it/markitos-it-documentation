terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 7.0.0"
    }
  }

  required_version = ">= 1.12.0, < 2.0.0"
}
