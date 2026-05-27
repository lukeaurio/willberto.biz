locals {
  secret_ids = toset([for secret in var.google_secrets : secret.disabled == true ? nonsensitive(secret.secret_id) : null])
}


resource "google_secret_manager_secret" "secrets" {
  for_each  = local.secret_ids
  project   = var.project_id
  secret_id = var.google_secrets[each.key].secret_id

  labels = merge(var.google_secrets[each.key].labels, {
    managed_by = "opentofu"
    env        = var.google_secrets[each.key].version_env
  })

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secrets" {
  for_each = local.secret_ids

  secret      = google_secret_manager_secret.secrets[each.key].id
  secret_data = templatefile(var.google_secrets[each.key].value, local.variable_overrides)
}
