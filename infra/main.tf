terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# -----------------------------
# Cloud Run Service
# -----------------------------
resource "google_cloud_run_v2_service" "llm_service" {
  name     = var.service_name
  location = var.region

  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository}/${var.image_name}:latest"

      resources {
        limits = {
          cpu    = "2"
          memory = "4Gi"
        }
      }

      env {
        name  = "ENV"
        value = "production"
      }
    }

    scaling {
      min_instance_count = 0
      max_instance_count = 3
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

# -----------------------------
# Allow public access
# -----------------------------
resource "google_cloud_run_service_iam_member" "public_invoker" {
  location = google_cloud_run_v2_service.llm_service.location
  service  = google_cloud_run_v2_service.llm_service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}