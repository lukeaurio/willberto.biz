locals {
  yaml_content   = var.helm_value_file != "" ? yamldecode(file("${var.helm_value_file}")) : {}
  variables_list = var.helm_value_file != "" ? concat([for k, v in local.yaml_content : { key = k, value = v }], var.helm_values) : var.helm_values
}

# This is the helm release resource. It will deploy the helm chart to the kubernetes cluster

resource "helm_release" "this" {
  name       = var.helm_release_name
  repository = var.helm_repository_url
  chart      = var.helm_chart_name
  version    = var.helm_chart_version
  namespace  = var.helm_namespace

  create_namespace = var.create_namespace
  atomic           = var.atomic
  timeout          = var.timeout
  cleanup_on_fail  = var.cleanup_on_fail
  wait             = var.wait
  reuse_values     = var.reuse_values
  description      = var.release_description

  values = local.variables_list

  dynamic "set" {
    for_each = var.set_values
    content {
      name  = set.value.name
      value = set.value.value
      type  = set.value.type
    }
  }

  dynamic "set_string" {
    for_each = var.set_string_values
    content {
      name  = set_string.value.name
      value = set_string.value.value
    }
  }

  dynamic "set_sensitive" {
    for_each = var.set_sensitive_values
    content {
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
      type  = set_sensitive.value.type
    }
  }

  dynamic "set" {
    #Generate Replica count if needed - This is a common value that many charts use, so we want to make it easy to set without having to create a values file or use the set_values variable. If replica_count is greater than 0, we will add it to the set values. If it is 0, we will not add it.
    for_each =  var.replica_count > 0 ? { "replicaCount" = var.replica_count } : {} 
    content {
      name  = "replicaCount"
      value = each.value
    }
  }
}