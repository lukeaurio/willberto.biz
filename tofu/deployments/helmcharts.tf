

module "helm" {
  source   = "../modules/helm"
  for_each = { for k, v in var.helm_releases : v.name => v }

  kubernetes_cluster_name = google_container_cluster.default.name
  project                 = var.project_id
  region                  = var.region
  helm_chart_name         = each.value.name
  helm_release_name       = each.value.name
  helm_repository_url     = each.value.repo_url
  helm_namespace          = each.value.namespace
  helm_chart_version      = each.value.version
  helm_value_file         = each.value.values_file
  replica_count           = each.value.replica_count
}