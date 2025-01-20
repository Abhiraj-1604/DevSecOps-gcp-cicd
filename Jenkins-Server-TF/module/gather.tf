# Get available zones in the specified region
data "google_compute_zones" "available" {
  region = var.region
  status = "UP"
}

# Get latest GKE version available
data "google_container_engine_versions" "supported" {
  location = var.region
}

# Get project details
data "google_project" "project" {
  project_id = var.project_id
}

# Get default compute service account
data "google_compute_default_service_account" "default" {}