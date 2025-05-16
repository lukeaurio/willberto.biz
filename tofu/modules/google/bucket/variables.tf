variable "name" {
  description = "The name of the bucket"
  type        = string
}

variable "location" {
  description = "The location of the bucket"
  type        = string
}

variable "project" {
  description = "The project ID where the bucket will be created"
  type        = string
}

variable "storage_class" {
  description = "The storage class of the bucket"
  type        = string
}

variable "public_access_prevention" {
  description = "The public access prevention setting for the bucket"
  type        = string
  default     = "enforced"
}

variable "uniform_bucket_level_access" {
  description = "Whether to enable uniform bucket-level access"
  type        = bool
}

variable "versioning" {
  description = "Whether to enable object versioning"
  type        = bool
  default     = true
}

variable "lifecycle_rules" {
  description = "The lifecycle rules for the bucket"
  type = list(object({
    age  = number
    type = string
  }))
}