variable "name" {
  description = "The ExternalSecret resource name."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.name))
    error_message = "name must be a valid Kubernetes DNS-1123 label."
  }
}

variable "namespace" {
  description = "The namespace where the ExternalSecret resource will be created."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.namespace))
    error_message = "namespace must be a valid Kubernetes DNS-1123 label."
  }
}

variable "resource_labels" {
  description = "Labels applied to the ExternalSecret custom resource metadata."
  type        = map(string)
  default     = {}
}

variable "resource_annotations" {
  description = "Annotations applied to the ExternalSecret custom resource metadata."
  type        = map(string)
  default     = {}
}

variable "refresh_interval" {
  description = "Refresh interval for ExternalSecret (for example 1h0m0s)."
  type        = string
  default     = "1h0m0s"

  validation {
    condition     = can(regex("^([0-9]+h)?([0-9]+m)?([0-9]+s)?$", var.refresh_interval)) && var.refresh_interval != ""
    error_message = "refresh_interval must be a duration string like 1h0m0s."
  }
}

variable "secret_store_name" {
  description = "The SecretStore or ClusterSecretStore name referenced by the ExternalSecret."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.secret_store_name))
    error_message = "secret_store_name must be a valid Kubernetes DNS-1123 label."
  }
}

variable "secret_store_kind" {
  description = "The kind of store referenced by the ExternalSecret."
  type        = string
  default     = "SecretStore"

  validation {
    condition     = contains(["SecretStore", "ClusterSecretStore"], var.secret_store_kind)
    error_message = "secret_store_kind must be one of: SecretStore, ClusterSecretStore."
  }
}

variable "target_secret_name" {
  description = "The Kubernetes Secret name that ExternalSecret will manage."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.target_secret_name))
    error_message = "target_secret_name must be a valid Kubernetes DNS-1123 label."
  }
}

variable "creation_policy" {
  description = "The ExternalSecret target creation policy."
  type        = string
  default     = "Owner"

  validation {
    condition     = contains(["Owner", "Orphan", "Merge", "None"], var.creation_policy)
    error_message = "creation_policy must be one of: Owner, Orphan, Merge, None."
  }
}

variable "data" {
  description = "Mappings from Kubernetes Secret keys to Google Secret Manager secret keys for the ExternalSecret."
  type = list(object({
    secret_key = string
    remote_key = string
    version    = optional(string)
    property   = optional(string)
  }))

  validation {
    condition     = length(var.data) > 0
    error_message = "data must contain at least one mapping item."
  }
  validation {
    condition     = alltrue([for item in var.data : can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", item.secret_key))])
    error_message = "Each secret_key in data must be a valid Kubernetes DNS-1123 label."
  }

}
