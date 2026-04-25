

#module "helm" {
#  source              = "../modules/helm"
#  for_each            = { for k, v in var.helm_releases : v.name => v if v.disabled != true }
#  helm_chart_name     = each.value.chart_name
#  helm_release_name   = each.value.name
#  helm_repository_url = each.value.repo_url
#  helm_namespace      = each.value.namespace
#  helm_chart_version  = each.value.version
#  helm_values         = each.value.values
#  helm_value_file     = "../../${each.value.values_file}" #Chartpaths are relative to the root of the module
#  replica_count       = each.value.replica_count
#  depends_on          = [resource.google_container_cluster.default]
#}