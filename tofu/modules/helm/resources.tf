locals {
  yaml_content   = var.helm_value_file != "" ? [file("${var.helm_value_file}")] : []
  variables_list = var.helm_value_file != "" ? concat(local.yaml_content, var.helm_values) : var.helm_values
  sa_name        = "${var.helm_release_name}-sa"
}

# This is the helm release resource. It will deploy the helm chart to the kubernetes cluster

resource "helm_release" "this" {
  name       = var.helm_release_name
  repository = var.helm_repository_url
  chart      = var.helm_chart_name
  version    = var.helm_chart_version == "latest" ? null : var.helm_chart_version # If version is set to "latest", we will pass null to use the latest version available in the repository. This allows users to easily use the latest version without having to update their configuration.
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
    for_each = var.replica_count > 0 ? { "replicaCount" = var.replica_count } : {}
    content {
      name  = set.key
      value = set.value
    }
  }
  depends_on = [kubernetes_service_account.this]
}

resource "kubernetes_service_account" "this" {
  count = var.create_service_account ? 1 : 0
  metadata {
    name      = local.sa_name
    namespace = var.helm_namespace
    annotations = merge(
      {
        "opentofu/managed-by"            = "terraform"
        "opentofu/helm-release"          = var.helm_release_name
        "iam.gke.io/gcp-service-account" = google_service_account.this[0].email
    }, var.service_account_annotations)
  }
  dynamic "secret" {
    for_each = toset(var.accessible_secrets != null ? var.accessible_secrets : [])
    content {
      name = secret.value
    }
  }
  depends_on = [helm_release.this]
}

resource "google_service_account" "this" {
  count        = var.create_service_account ? 1 : 0
  account_id   = "${var.helm_release_name}-sa"
  display_name = "${var.helm_release_name} Service Account"
}

resource "google_project_iam_member" "this" {
  for_each   = var.create_service_account ? toset(var.gcp_roles != null ? concat(var.gcp_roles, "roles/iam.workloadIdentityUser") : []) : toset([])
  project    = var.gcp_project_id
  role       = each.value
  member     = "serviceAccount:${google_service_account.this[0].email}"
  depends_on = [kubernetes_service_account.this]
}
