variable "name" {
  description = "The name of the bucket"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9._-]{1,61}[a-z0-9]$", var.name))
    error_message = "Bucket name must be 3-63 characters, start and end with a letter or number, and contain only lowercase letters, numbers, hyphens, underscores, and dots."
  }
}

variable "location" {
  description = "The location of the bucket"
  type        = string
  validation {
    condition     = can(regex("^[A-Z][A-Z0-9-]+$", var.location))
    error_message = "Location must be a valid GCS location in uppercase (e.g., US, EU, ASIA, US-CENTRAL1, EUROPE-WEST1)."
  }
}

variable "project" {
  description = "The project ID where the bucket will be created"
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project))
    error_message = "Project ID must be 6-30 characters, start with a lowercase letter, and contain only lowercase letters, digits, and hyphens."
  }
}

variable "storage_class" {
  description = "The storage class of the bucket"
  type        = string
  validation {
    condition     = contains(["STANDARD", "NEARLINE", "COLDLINE", "ARCHIVE"], var.storage_class)
    error_message = "Storage class must be one of: STANDARD, NEARLINE, COLDLINE, ARCHIVE."
  }
}

variable "public_access_prevention" {
  description = "The public access prevention setting for the bucket"
  type        = string
  default     = "enforced"
  validation {
    condition     = contains(["enforced", "inherited"], var.public_access_prevention)
    error_message = "public_access_prevention must be either 'enforced' or 'inherited'."
  }
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
  validation {
    condition     = alltrue([for r in var.lifecycle_rules : r.age >= 0])
    error_message = "All lifecycle rule ages must be greater than or equal to 0."
  }
  validation {
    condition     = alltrue([for r in var.lifecycle_rules : contains(["Delete", "SetStorageClass", "AbortIncompleteMultipartUpload"], r.type)])
    error_message = "All lifecycle rule types must be one of: Delete, SetStorageClass, AbortIncompleteMultipartUpload."
  }
}