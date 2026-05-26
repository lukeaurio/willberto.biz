resource "google_secret_manager_secret" "secrets" {
  for_each = {
    for secret in var.google_secrets :
    secret.secret_id => secret
    if secret.disabled != true
  }
  project   = var.project_id
  secret_id = each.value.secret_id

  labels = merge(each.value.labels, {
    managed_by = "opentofu"
    env        = each.value.version_env
  })

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secrets" {
  for_each = {
    for secret in var.google_secrets :
    secret.secret_id => secret
    if secret.disabled != true
  }

  secret      = google_secret_manager_secret.secrets[each.key].id
  secret_data = templatefile(each.value.value, local.variable_overrides)
}
