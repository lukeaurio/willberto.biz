# Copyright @lukeaurio
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# ------------------------------------------------------------------------------
# Helm Chart Configuration
# Variables for specifying the Helm chart, its version, and repository.
# ------------------------------------------------------------------------------

variable "helm_chart_name" {
  description = "The name of the Helm chart to be deployed (e.g., 'nginx', 'prometheus'). This is a required field for identifying the chart in the repository."
  type        = string
}

variable "helm_chart_version" {
  description = "The specific version of the Helm chart to be deployed (e.g., '1.16.0'). Pinning the version ensures repeatable deployments. This can be null or empty to use the latest version available in the repository."
  type        = string
  validation {
    condition     = var.helm_chart_version == null || var.helm_chart_version != ""
    error_message = "The Helm chart version must be a non-empty string or null."
  }
  validation {
    condition     = var.helm_chart_version == "latest" || can(regex("^\\d+\\.\\d+\\.\\d+$", var.helm_chart_version))
    error_message = "The Helm chart version must be 'latest' or a valid semantic version (e.g., '1.16.0')"
  }
}

variable "helm_repository_url" {
  description = "The URL of the Helm repository containing the chart (e.g., 'oci://ghcr.io/bitnami'). This must be an OCI URL or Google Storage URL where Helm will fetch the chart from."
  type        = string
  validation {
    condition     = can(regex("^(oci://|gs://)", var.helm_repository_url))
    error_message = "The Helm repository URL must be an OCI URL starting with 'oci://' or a Google Storage URL starting with 'gs://'."
  }
}

# ------------------------------------------------------------------------------
# Helm Release Configuration
# Variables that control the behavior and lifecycle of the Helm release.
# ------------------------------------------------------------------------------

variable "helm_release_name" {
  description = "The name of the Helm release to be created in the Kubernetes cluster. This name is used to track and manage the deployment."
  type        = string
}

variable "helm_namespace" {
  description = "The Kubernetes namespace in which to deploy the Helm release. If the namespace does not exist, it can be created based on the 'create_namespace' variable."
  type        = string
}

variable "create_namespace" {
  description = "A boolean flag indicating whether to create the Kubernetes namespace if it does not already exist. Defaults to false."
  type        = bool
  default     = false
}

variable "atomic" {
  description = "If true, the release process will be atomic. This means that if the release fails, Helm will attempt to roll back to the previous version. Defaults to false."
  type        = bool
  default     = false
}

variable "timeout" {
  description = "Time in seconds to wait for any individual Kubernetes operation (like Jobs for hooks) during the Helm release process. Defaults to 300 seconds."
  type        = number
  default     = 300
}

variable "cleanup_on_fail" {
  description = "A boolean flag that, if true, allows Helm to delete new resources created in this release in the event that the upgrade or installation fails. Defaults to false."
  type        = bool
  default     = false
}

variable "wait" {
  description = "If true, Helm will wait until all resources deployed by the chart are in a ready state before marking the release as successful. Defaults to true."
  type        = bool
  default     = true
}

variable "reuse_values" {
  description = "When upgrading a release, if true, Helm will reuse the values from the last release and merge in any overrides. If false, charts are deployed with their default values. Defaults to false."
  type        = bool
  default     = false
}

variable "release_description" {
  description = "An optional human-readable description for the Helm release. This can be useful for adding notes or context about the deployment."
  type        = string
  default     = null
}

# ------------------------------------------------------------------------------
# Helm Value Configuration
# Variables for providing configuration values to the Helm chart.
# This includes values from files, direct key-value pairs, and specific set operations.
# ------------------------------------------------------------------------------

variable "helm_value_file" {
  description = "The path to a custom Helm values YAML file. Values from this file will be merged with other value settings."
  type        = string
  default     = "" # Default to empty string, indicating no file is used unless specified.

  validation {
    condition     = var.helm_value_file == "" || can(file(var.helm_value_file))
    error_message = "The specified helm_value_file does not exist or cannot be read. Please provide a valid file path or leave it empty."
  }
}

variable "helm_values" {
  description = "A list of strings representing values to be passed directly to the Helm chart (e.g., ['key1=value1', 'key2=value2']). These are typically merged with values from files."
  type        = list(string)
  default     = []
}

variable "replica_count" {
  description = "A common Helm chart value: the number of replicas of the application to deploy. This is provided as a convenience but can also be set via 'set_values' or a values file."
  type        = number
  default     = 0 # Default to not setting a replica set in tofu
  validation {
    condition     = var.replica_count >= 0
    error_message = "replica_count must be a non-negative integer."
  }
}

variable "set_values" {
  description = "A list of objects to set specific values in the Helm chart. Each object must have 'name' (string) and 'value' (string). An optional 'type' (string, e.g., 'string', 'bool', 'int') can be specified; defaults to 'auto'."
  type = list(object({
    name  = string
    value = string
    type  = optional(string, "auto")
  }))
  default = []
}

variable "set_sensitive_values" {
  description = "A list of objects to set sensitive values in the Helm chart (e.g., passwords, API keys). These values are not logged by Helm. Each object must have 'name' (string) and 'value' (string). An optional 'type' (string) can be specified; defaults to 'auto'."
  type = list(object({
    name  = string
    value = string
    type  = optional(string, "auto")
  }))
  default = []
}