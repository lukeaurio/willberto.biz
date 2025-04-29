locals {
  yaml_content   = var.helm_value_file != "" ? yamldecode(file("${path.module}/${var.helm_value_file}/config.yaml")) : {}
  variables_list = var.helm_value_file != "" ? concat([for k, v in local.yaml_content : { key = k, value = v }], var.helm_values) : var.helm_values
}

resource "helm_release" "this" {
  name       = var.helm_release_name
  repository = var.helm_repository_url
  chart      = var.helm_chart_name
  version    = var.helm_chart_version
  namespace  = var.helm_namespace

  values = local.variables_list

  set {
    name  = "replicaCount"
    value = var.replica_count
  }
}