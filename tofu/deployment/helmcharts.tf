
module "helm" {
  source                 = "../modules/helm"
  for_each               = { for k, v in var.helm_releases : v.name => v if v.disabled == false && v.uses_external_secret == false }
  gcp_project_id         = var.project_id
  gcp_project_name       = local.project_name_sanitized
  helm_chart_name        = each.value.chart_name
  helm_release_name      = each.value.name
  helm_repository_url    = each.value.repo_url
  helm_namespace         = each.value.namespace
  helm_chart_version     = each.value.version
  helm_values            = each.value.values
  helm_value_file        = "../../${each.value.values_file}" #Chartpaths are relative to the root of the module
  replica_count          = each.value.replica_count
  timeout                = each.value.timeout
  create_service_account = each.value.create_service_account
  create_namespace       = each.value.create_namespace
  accessible_secrets     = each.value.service_account_accessible_secrets
  gcp_roles              = each.value.service_account_gcp_roles
  depends_on             = [resource.google_container_cluster.autopilot]
}

module "namespaces" {
  source   = "../modules/kube/namespace"
  for_each = { for k, v in var.helm_releases : v.name => v if v.disabled == false && v.uses_external_secret == true }
  name     = each.value.namespace
  labels = merge(
    {
      "opentofu/managed-by" = "terraform"
    }
  )
  annotations = {}
}

module "helm_with_external_secrets" {
  source                 = "../modules/helm"
  for_each               = { for k, v in var.helm_releases : v.name => v if v.disabled == false && v.uses_external_secret == true }
  gcp_project_id         = var.project_id
  gcp_project_name       = local.project_name_sanitized
  helm_chart_name        = each.value.chart_name
  helm_release_name      = each.value.name
  helm_repository_url    = each.value.repo_url
  helm_namespace         = each.value.namespace
  helm_chart_version     = each.value.version
  helm_values            = each.value.values
  helm_value_file        = "../../${each.value.values_file}" #Chartpaths are relative to the root of the module
  replica_count          = each.value.replica_count
  timeout                = each.value.timeout
  create_service_account = each.value.create_service_account
  create_namespace       = each.value.create_namespace
  accessible_secrets     = each.value.service_account_accessible_secrets
  gcp_roles              = each.value.service_account_gcp_roles
  depends_on             = [resource.google_container_cluster.autopilot, module.helm_external_secrets, module.namespaces]
}
