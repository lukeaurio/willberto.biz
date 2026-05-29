output "helm_release_name" {
  description = "The name of the Helm release."
  value       = helm_release.this.name
}

output "helm_release_namespace" {
  description = "The namespace of the Helm release."
  value       = helm_release.this.namespace
}

output "service_account_name" {
  description = "The name of the service account created for the Helm release."
  value       = try(kubernetes_service_account.this[0].metadata[0].name, null)
}

output "service_account_namespace" {
  description = "The namespace of the service account created for the Helm release."
  value       = try(kubernetes_service_account.this[0].metadata[0].namespace, null)
}