# GCP Project Configuration

variable "project_id" {
  description = "The GCP Project ID"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "The region for the GCP resources"
  type        = string
  sensitive   = true
  validation {
    condition     = contains(["us-central1", "us-east1", "us-east4", "us-west1", "us-west2", "us-west3", "us-west4"], var.region)
    error_message = "The region must be one of the US regions: us-central1, us-east1, us-east4, us-west1, us-west2, us-west3, us-west4."
  }
}

variable "zone" {
  description = "The zone for the GCP resources"
  type        = string
  sensitive   = true
  validation {
    condition     = contains(["us-central1-a", "us-central1-b", "us-central1-c", "us-central1-f", "us-east1-b", "us-east1-c", "us-east1-d", "us-east4-a", "us-west1-a", "us-west1-b", "us-west2-a", "us-west2-b", "us-west3-a", "us-west3-b", "us-west4-a"], var.zone)
    error_message = "The zone must be one of the US zones: us-central1-a, us-central1-b, us-central1-c, us-central1-f, us-east1-b, us-east1-c, us-east1-d, us-east4-a, us-west1-a, us-west1-b, us-west2-a, us-west2-b, us-west3-a, us-west3-b, us-west4-a."
  }
}

# Cloudflare Configuration
variable "cloudflare_api_token" {
  description = "The Cloudflare API Token"
  type        = string
  sensitive   = true
}

# Google Cloud Storage Buckets Configuration
variable "buckets" {
  description = "Map of GCS buckets to create"
  type = list(object({
    name                        = string
    storage_class               = string
    public_access_prevention    = string
    uniform_bucket_level_access = bool
    versioning                  = optional(bool)
    lifecycle_rules = list(object({
      age  = number
      type = string
    }))
  }))
  default = []
}

# Helm Releases Configuration
variable "helm_releases" {
  description = "Map of Helm releases to deploy"
  type = list(object({
    name          = string
    namespace     = string
    repo_url      = string
    chart         = string
    version       = string
    values        = optional(list(string))
    values_file   = optional(string)
    replica_count = number
  }))
  default = []
}