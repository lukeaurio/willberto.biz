variable "project" {
  description = "The GCP Project ID"
  type        = string
}

variable "region" {
  description = "The region for the GCP resources"
  type        = string
}

variable "buckets" {
  description = "Map of Google Cloud Storage buckets to create"
  type        = map(object({
    storage_class               = string
    public_access_prevention    = string
    uniform_bucket_level_access = bool
    versioning                  = optional(bool)
    lifecycle_rules             = list(object({
      age  = number
      type = string
    }))
  }))
  default     = {}
}