variable "kubernetes_cluster_name" {
    description = "The name of the Kubernetes cluster"
    type        = string
}

variable "kubernetes_cluster_endpoint" {
    description = "The endpoint of the Kubernetes cluster"
    type        = string
}

variable "kubernetes_cluster_ca_certificate" {
    description = "The CA certificate of the Kubernetes cluster"
    type        = string
}

variable "kubernetes_admin_username" {
    description = "The admin username for the Kubernetes cluster"
    type        = string
}

variable "kubernetes_admin_password" {
    description = "The admin password for the Kubernetes cluster"
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

variable "helm_release_name" {
    description = "The name of the Helm release"
    type        = string
}

variable "helm_namespace" {
    description = "The namespace in which to deploy the Helm release"
    type        = string
}