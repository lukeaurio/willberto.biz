variable "kubernetes_cluster_name" {
    description = "The name of the Kubernetes cluster"
    type        = string
}

variable "project" {
    description = "The GCP project ID"
    type        = string
}

variable "region" {
    description = "The region where the GKE cluster is located"
    type        = string
}

variable "helm_repository_url" {
    description = "The URL of the Helm repository"
    type        = string
}

variable "helm_chart_name" {
    description = "The name of the Helm chart"
    type        = string
}

variable "helm_chart_version" {
    description = "The version of the Helm chart"
    type        = string
}

variable "helm_namespace" {
    description = "The namespace in which to deploy the Helm release"
    type        = string
}

variable "replica_count" {
    description = "The number of replicas to deploy"
    type        = number
}