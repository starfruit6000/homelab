terraform {
  backend "gcs" {
    bucket = "state-fb107052ecea5c81"
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
  project = var.project_id
  region  = var.region
}
