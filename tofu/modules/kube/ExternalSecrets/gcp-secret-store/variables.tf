variable "secret_store_name" {
  description = "Name of the SecretStore or ClusterSecretStore resource."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.secret_store_name))
    error_message = "secret_store_name must be a valid Kubernetes DNS-1123 label."
  }
}

variable "secret_store_kind" {
  description = "External Secrets store kind."
  type        = string
  default     = "ClusterSecretStore"

  validation {
    condition     = contains(["SecretStore", "ClusterSecretStore"], var.secret_store_kind)
    error_message = "secret_store_kind must be SecretStore or ClusterSecretStore."
  }
}

variable "namespace" {
  description = "Namespace for SecretStore metadata (when kind is SecretStore) and for serviceAccountRef namespace (when kind is ClusterSecretStore)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.namespace))
    error_message = "namespace must be a valid Kubernetes DNS-1123 label."
  }
}

variable "gcp_project_id" {
  description = "Google Cloud project ID used by gcpsm provider."
  type        = string

  validation {
    condition     = can(regex("^[a-z][-a-z0-9:.]{4,61}[a-z0-9]$", var.gcp_project_id))
    error_message = "gcp_project_id must be a valid GCP project ID."
  }
}

variable "service_account_name" {
  description = "Kubernetes service account name used by workload identity."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.service_account_name))
    error_message = "service_account_name must be a valid Kubernetes DNS-1123 label."
  }
}
