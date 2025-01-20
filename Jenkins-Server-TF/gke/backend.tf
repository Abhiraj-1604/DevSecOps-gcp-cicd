terraform {
  required_version = "~> 1.5.7"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.10.0"
    }
  }
  backend "gcs" {
    bucket = "cloudhustler"
    prefix = "gke/terraform.tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
