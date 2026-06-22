module "helm_external_secret_stores" {
  source               = "../modules/kube/ExternalSecrets/gcp-secret-store"
  for_each             = { for k, v in var.helm_external_secret_stores : v.name => v if v.disabled != true && v.secret_store_kind == "ClusterSecretStore" }
  secret_store_name    = each.value.name
  secret_store_kind    = each.value.secret_store_kind
  namespace            = module.helm["external-secrets"].helm_release_namespace
  gcp_project_id       = var.project_id
  service_account_name = module.helm["external-secrets"].service_account_name
  depends_on           = [module.helm["external-secrets"]]
}

module "helm_external_secrets" {
  source               = "../modules/kube/ExternalSecrets/gcp-external-secret"
  for_each             = { for k, v in var.helm_external_secrets : v.name => v if v.disabled != true }
  name                 = each.value.name
  namespace            = each.value.namespace
  resource_labels      = each.value.resource_labels
  resource_annotations = each.value.resource_annotations
  refresh_interval     = each.value.refresh_interval
  secret_store_name    = each.value.secret_store_name
  secret_store_kind    = each.value.secret_store_kind
  target_secret_name   = each.value.target_secret_name
  creation_policy      = each.value.creation_policy
  data = [for item in each.value.data : {
    secret_key = item.secret_key
    remote_key = try(google_secret_manager_secret.secrets[item.remote_key].secret_id, item.remote_key)
    version    = try(item.version, null)
    property   = try(item.property, null)
  }]
  depends_on = [module.helm_external_secret_stores, google_secret_manager_secret_version.secrets, module.namespaces]
}
