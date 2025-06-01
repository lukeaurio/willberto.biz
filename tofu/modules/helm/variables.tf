variable "kubernetes_cluster_name" {
  description = "The name of the Kubernetes cluster where the Helm chart will be deployed"
  type        = string
}

variable "project_id" {
  description = "The Google Cloud Platform (GCP) project ID where the resources will be created"
  type        = string
}

variable "region" {
  description = "The GCP region where the GKE cluster is located"
  type        = string
}

variable "helm_release_name" {
  description = "The name of the Helm release to be created"
  type        = string
}

variable "helm_repository_url" {
  description = "The URL of the Helm repository containing the chart"
  type        = string
}

variable "helm_chart_name" {
  description = "The name of the Helm chart to be deployed"
  type        = string
}

variable "helm_value_file" {
  description = "The path to the Helm values file that contains configuration values for the chart"
  type        = string
}

variable "helm_values" {
  description = "A map of values to be passed to the Helm chart"
  type        = list(string)
  default     = []
}

variable "helm_chart_version" {
  description = "The specific version of the Helm chart to be deployed"
  type        = string
}

variable "helm_namespace" {
  description = "The Kubernetes namespace in which to deploy the Helm release"
  type        = string
}

variable "replica_count" {
  description = "The number of replicas of the application to deploy"
  type        = number
}