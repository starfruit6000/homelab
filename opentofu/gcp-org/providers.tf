terraform {
  backend "gcs" {
    bucket = var.project_id
    prefix = var.project_id
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.9"
    }
  }

  required_version = ">= 1.16.0"
}

provider "google" {
  project               = var.project_id
  region                = var.region
  billing_project       = "state-986ecc0fd7e6ac68"
  user_project_override = true
}
