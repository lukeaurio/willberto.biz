output "external_secret_name" {
  description = "The name of the created ExternalSecret custom resource."
  value       = kubernetes_manifest.this.object.metadata.name
}

output "external_secret_namespace" {
  description = "The namespace of the created ExternalSecret custom resource."
  value       = kubernetes_manifest.this.object.metadata.namespace
}

output "target_secret_name" {
  description = "The target Kubernetes Secret name managed by the ExternalSecret."
  value       = var.target_secret_name
}

output "secret_store_name" {
  description = "The SecretStore or ClusterSecretStore referenced by the ExternalSecret."
  value       = var.secret_store_name
}

output "secret_store_kind" {
  description = "The kind of External Secrets store referenced by the ExternalSecret."
  value       = var.secret_store_kind
}

output "external_secret_manifest" {
  description = "The generated ExternalSecret manifest object."
  value       = kubernetes_manifest.this.manifest
}
