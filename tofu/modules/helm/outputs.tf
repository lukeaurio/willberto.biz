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

output "secret_store_name" {
  description = "The name of the created SecretStore or ClusterSecretStore."
  value       = try(kubernetes_manifest.secret_store[0].object.metadata.name, null)
}

output "secret_store_namespace" {
  description = "The namespace of the created SecretStore. Null when creating a ClusterSecretStore."
  value       = try(kubernetes_manifest.secret_store[0].object.metadata.namespace, null)
}

output "secret_store_kind" {
  description = "The kind of External Secrets store created by this module."
  value       = try(kubernetes_manifest.secret_store[0].object.kind, null)
}

output "secret_store_manifest" {
  description = "The generated SecretStore or ClusterSecretStore manifest object."
  value       = try(kubernetes_manifest.secret_store[0].manifest, null)
}
