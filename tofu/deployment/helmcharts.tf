
module "helm" {
  source              = "../modules/helm"
  for_each            = { for k, v in var.helm_releases : v.name => v if v.disabled != true }
  gcp_project_id      = var.project_id
  gcp_project_name    = var.project_name
  helm_chart_name     = each.value.chart_name
  helm_release_name   = each.value.name
  helm_repository_url = each.value.repo_url
  helm_namespace      = each.value.namespace
  helm_chart_version  = each.value.version
  helm_values         = each.value.values
  helm_value_file     = "../../${each.value.values_file}" #Chartpaths are relative to the root of the module
  replica_count       = each.value.replica_count
  depends_on          = [resource.google_container_cluster.autopilot]
}

module "helm_external_secret_stores" {
  source               = "../modules/kube/ExternalSecrets/gcp-secret-store"
  for_each             = { for k, v in var.helm_external_secret_stores : v.name => v if v.disabled != true }
  secret_store_name    = each.value.name
  secret_store_kind    = each.value.secret_store_kind
  namespace            = each.value.namespace
  gcp_project_id       = var.project_id
  service_account_name = each.value.service_account_name
  depends_on           = [module.helm]
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
  data                 = each.value.data
  depends_on           = [module.helm_external_secret_stores, google_secret_manager_secret_version.example]
}