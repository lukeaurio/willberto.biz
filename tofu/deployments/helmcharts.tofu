module "helm" {
    source = "../modules/helm"
    for_each = var.helm_releases

    kubernetes_cluster_name = google_container_cluster.default.name
    project                 = var.project
    region                  = var.region
    helm_chart_name         = each.value.name
    helm_repository_url     = each.value.repo_url
    helm_namespace          = each.value.namespace
    helm_chart_name         = each.value.chart
    helm_chart_version      = each.value.version
    values                  = each.value.values
}