data "template_file" "helm_chart_path" {
    count = var.helm_chart_path != "" ? 1 : 0
    template = var.helm_chart_path
}

resource "helm_release" "this" {
    name       = var.helm_release_name
    repository = var.helm_repository_url
    chart      = var.helm_chart_name
    version    = var.helm_chart_version
    namespace  = var.helm_namespace

    values = [file("${path.module}/${var.helm_chart_path}/values.yaml")]

    set {
        name  = "replicaCount"
        value = var.replica_count
    }
}