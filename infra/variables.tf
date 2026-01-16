variable "project_id" {
  type        = string
  description = "GCP project ID"
  default     = "airy-harbor-483517-s2"
}

variable "region" {
  type        = string
  description = "Deployment region"
  default     = "europe-north2"
}

variable "repository" {
  type        = string
  description = "Artifact Registry repository name"
  default     = "neoguru"
}

variable "image_name" {
  type        = string
  description = "Docker image name"
  default     = "llm-single-model"
}

variable "service_name" {
  type        = string
  description = "Cloud Run service name"
  default     = "neoguru-llm"
}