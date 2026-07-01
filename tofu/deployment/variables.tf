# GCP Project Configuration

variable "project_id" {
  description = "The GCP Project ID"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "The GCP Project Name"
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
  validation {
    condition     = length(var.cloudflare_api_token) > 0
    error_message = "The Cloudflare API token cannot be empty."
  }
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID associated with the Token"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.cloudflare_account_id) > 0
    error_message = "The Cloudflare account ID cannot be empty."
  }
}

# GitHub Token Configuration
# This token is used for accessing private GitHub repositories and the GitHub Container Registry (GHCR).
# It should be formatted as base64 encoded string of <username>:<personal_access_token>
variable "ghcr_token" {
  description = "The GitHub Container Registry (GHCR) Auth Token, formatted as base64 encoded string of <username>:<personal_access_token>"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.ghcr_token) > 0
    error_message = "The GitHub Container Registry (GHCR) token cannot be empty."
  }

  validation {
    condition     = can(base64decode(var.ghcr_token))
    error_message = "The GitHub Container Registry (GHCR) token must be a valid base64 encoded string."
  }
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
    name                               = string
    namespace                          = string
    chart_name                         = string
    repo_url                           = string
    version                            = string
    values                             = optional(list(string), [])
    values_file                        = optional(string, "")
    replica_count                      = number # When Set to Zero, it reverts to using the Chart's Definition of replicasets
    timeout                            = optional(number, 300)
    create_service_account             = optional(bool, false)
    create_namespace                   = optional(bool, true)
    service_account_accessible_secrets = optional(list(string), [])
    service_account_gcp_roles          = optional(list(string), [])
    uses_external_secret               = optional(bool, false) # If true will wait to create the helm chart until after external secrets are created, (for helm charts which need secrets)
    uses_cf_ingress                    = optional(bool, false) # If true will wait to create the helm chart until after cloudflare-ingress is created, (for helm charts which need ingress)
    disabled                           = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for release in var.helm_releases :
      release.values_file == "" || (release.values_file != "" && can(file("../../${release.values_file}")))
    ])
    error_message = "Helm Charts: All charts with a values file must be a file inside the current repository"
  }

  validation {
    condition = alltrue([
      for release in var.helm_releases :
      release.replica_count >= 0
    ])
    error_message = "Helm Charts: replica_count must be a non-negative integer for all releases"
  }

  validation {
    condition = alltrue([
      for release in var.helm_releases :
      release.timeout > 0 && release.timeout == floor(release.timeout)
    ])
    error_message = "Helm Charts: timeout must be a positive integer number of seconds for all releases"
  }

  validation {
    condition = alltrue([
      for release in var.helm_releases :
      length(release.values) == 0 || (length(release.values) > 0 && alltrue([
        for value in release.values : can(regex("^[^=]+=[^=]+$", value))
      ]))
    ])
    error_message = "Helm Charts: All fields (name, namespace, chart_name, repo_url, version) must be non-empty for all releases"
  }

  validation {
    condition = alltrue([
      for release in var.helm_releases :
      release.repo_url != "" && (can(regex("^(oci://|gs://|https://)", release.repo_url)))
    ])
    error_message = "Helm Charts: repo_url must be a valid URL (https, oci, or gs) for all releases"
  }

  validation {
    condition = alltrue([
      for release in var.helm_releases :
      release.name != "" && release.namespace != "" && release.chart_name != "" && release.repo_url != "" && release.version != ""
    ])
    error_message = "Helm Charts: All fields (name, namespace, chart_name, repo_url, version) must be non-empty for all releases"
  }

  validation {
    condition = alltrue([
      for release in var.helm_releases :
      length(release.service_account_accessible_secrets) == length(distinct(release.service_account_accessible_secrets))
    ])
    error_message = "Helm Charts: service_account_accessible_secrets must contain unique values"
  }

  validation {
    condition = alltrue([
      for release in var.helm_releases :
      length(release.service_account_gcp_roles) == length(distinct(release.service_account_gcp_roles))
    ])
    error_message = "Helm Charts: service_account_gcp_roles must contain unique values"
  }

  validation {
    condition = alltrue([
      for release in var.helm_releases :
      (release.create_namespace == true && release.uses_external_secret == false) || (release.create_namespace == false && release.uses_external_secret == true)
    ])
    error_message = "Helm Charts: Helm releases that use external secrets must have create_namespace set to true to ensure the namespace exists before creating ExternalSecret resources."
  }
}

# External Secrets SecretStore / ClusterSecretStore configuration
variable "helm_external_secret_stores" {
  description = "List of External Secrets stores to create in the cluster."
  type = list(object({
    name                 = string
    namespace            = string
    secret_store_kind    = optional(string, "ClusterSecretStore")
    service_account_name = string
    disabled             = optional(bool, false)
    uses_external_secret = optional(bool, false) # If true will wait to create the helm chart until after secret stores are created, (for helm charts which need secrets)
  }))
  default = []

  validation {
    condition = alltrue([
      for store in var.helm_external_secret_stores :
      store.name != "" && can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", store.name))
    ])
    error_message = "External Secret Stores: name must be a non-empty Kubernetes DNS-1123 label for all items."
  }

  validation {
    condition = alltrue([
      for store in var.helm_external_secret_stores :
      store.namespace != "" && can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", store.namespace))
    ])
    error_message = "External Secret Stores: namespace must be a non-empty Kubernetes DNS-1123 label for all items."
  }

  validation {
    condition = alltrue([
      for store in var.helm_external_secret_stores :
      can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", store.service_account_name))
    ])
    error_message = "External Secret Stores: service_account_name must be a valid Kubernetes DNS-1123 label for all items."
  }

  validation {
    condition = alltrue([
      for store in var.helm_external_secret_stores :
      contains(["SecretStore", "ClusterSecretStore"], store.secret_store_kind)
    ])
    error_message = "External Secret Stores: secret_store_kind must be one of: SecretStore, ClusterSecretStore."
  }

  validation {
    condition = length(var.helm_external_secret_stores) == length(distinct([
      for store in var.helm_external_secret_stores : "${store.secret_store_kind}|${store.namespace}|${store.name}"
    ]))
    error_message = "External Secret Stores: duplicate store identifiers are not allowed (kind + namespace + name must be unique)."
  }
}

# ExternalSecret resources configuration
variable "helm_external_secrets" {
  description = "List of ExternalSecret resources to create."
  type = list(object({
    name                 = string
    namespace            = string
    resource_labels      = optional(map(string), {})
    resource_annotations = optional(map(string), {})
    refresh_interval     = optional(string, "1h0m0s")
    secret_type          = optional(string, "generic")
    secret_store_name    = string
    secret_store_kind    = optional(string, "ClusterSecretStore")
    target_secret_name   = string
    creation_policy      = optional(string, "Owner")
    data = list(object({
      secret_key = string
      remote_key = string
      version    = optional(string)
      property   = optional(string)
    }))
    disabled = optional(bool, false)
  }))
  default = []

  validation {
    condition = alltrue([
      for secret in var.helm_external_secrets :
      secret.name != "" && can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", secret.name))
    ])
    error_message = "External Secrets: name must be a non-empty Kubernetes DNS-1123 label for all items."
  }

  validation {
    condition = alltrue([
      for secret in var.helm_external_secrets :
      secret.namespace != "" && can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", secret.namespace))
    ])
    error_message = "External Secrets: namespace must be a non-empty Kubernetes DNS-1123 label for all items."
  }

  validation {
    condition = alltrue([
      for secret in var.helm_external_secrets :
      can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", secret.secret_store_name))
    ])
    error_message = "External Secrets: secret_store_name must be a valid Kubernetes DNS-1123 label for all items."
  }

  validation {
    condition = alltrue([
      for secret in var.helm_external_secrets :
      contains(["SecretStore", "ClusterSecretStore"], secret.secret_store_kind)
    ])
    error_message = "External Secrets: secret_store_kind must be one of: SecretStore, ClusterSecretStore."
  }

  validation {
    condition = alltrue([
      for secret in var.helm_external_secrets :
      can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", secret.target_secret_name))
    ])
    error_message = "External Secrets: target_secret_name must be a valid Kubernetes DNS-1123 label for all items."
  }

  validation {
    condition = alltrue([
      for secret in var.helm_external_secrets :
      contains(["Owner", "Orphan", "Merge", "None"], secret.creation_policy)
    ])
    error_message = "External Secrets: creation_policy must be one of: Owner, Orphan, Merge, None."
  }

  validation {
    condition = alltrue([
      for secret in var.helm_external_secrets :
      can(regex("^([0-9]+h)?([0-9]+m)?([0-9]+s)?$", secret.refresh_interval)) && secret.refresh_interval != ""
    ])
    error_message = "External Secrets: refresh_interval must be a duration string like 1h0m0s for all items."
  }

  validation {
    condition = alltrue([
      for secret in var.helm_external_secrets :
      length(secret.data) > 0
    ])
    error_message = "External Secrets: each item must include at least one data mapping."
  }

  validation {
    condition = alltrue(flatten([
      for secret in var.helm_external_secrets : [
        for mapping in secret.data :
        contains(concat([for s in var.google_secrets : s.secret_id], ["cloudflare-api-token"]), mapping.remote_key)
      ]
    ]))
    error_message = "External Secrets: each item must reference a created Google Secret from google_secrets with matching secret_id."
  }

  validation {
    condition = alltrue(flatten([
      for secret in var.helm_external_secrets : [
        for mapping in secret.data :
        mapping.secret_key != "" && mapping.remote_key != ""
      ]
    ]))
    error_message = "External Secrets: every data mapping must include non-empty secret_key and remote_key values."
  }

  validation {
    condition = alltrue([
      for secret in var.helm_external_secrets :
      length([for s in var.helm_external_secret_stores : s if s.disabled != true && s.name == secret.secret_store_name && s.secret_store_kind == secret.secret_store_kind]) > 0
    ])
    error_message = "External Secrets: each item must reference an enabled store from helm_external_secret_stores with matching secret_store_name and secret_store_kind."
  }
}

# Optional Google Secret Manager secrets useful for ExternalSecret examples
variable "google_secrets" {
  description = "Optional Google Secret Manager secrets created by Terraform for ExternalSecret testing."
  type = list(object({
    secret_id   = string
    value       = map(string)
    labels      = optional(map(string), {})
    disabled    = optional(bool, false)
    version_env = optional(string, "example")
  }))
  default   = []
  sensitive = true

  validation {
    condition = alltrue([
      for secret in var.google_secrets :
      can(regex("^[A-Za-z0-9_-]+$", secret.secret_id))
    ])
    error_message = "Example Google Secrets: secret_id must contain only letters, numbers, underscores, and hyphens."
  }

  validation {
    condition = alltrue([
      for secret in var.google_secrets :
      length(keys(secret.value)) > 0
    ])
    error_message = "Example Google Secrets: value must be non-empty for all items."
  }

  validation {
    condition = length(var.google_secrets) == length(distinct([
      for secret in var.google_secrets : secret.secret_id
    ]))
    error_message = "Example Google Secrets: secret_id values must be unique."
  }
}
