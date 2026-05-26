output "secret_store_name" {
  description = "Name of the created SecretStore or ClusterSecretStore."
  value       = kubernetes_manifest.this.object.metadata.name
}

output "secret_store_kind" {
  description = "Kind of the created External Secrets store resource."
  value       = kubernetes_manifest.this.object.kind
}

output "secret_store_namespace" {
  description = "Namespace of the created SecretStore. Null for ClusterSecretStore."
  value       = try(kubernetes_manifest.this.object.metadata.namespace, null)
}
