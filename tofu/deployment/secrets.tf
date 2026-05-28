locals {
  secret_ids    = nonsensitive(toset(compact([for secret in var.google_secrets : !secret.disabled ? nonsensitive(secret.secret_id) : null])))
  secret_values = { for secret in var.google_secrets : secret.secret_id => secret }
}


resource "google_secret_manager_secret" "secrets" {
  for_each  = local.secret_ids
  project   = var.project_id
  secret_id = each.key

  labels = merge(local.secret_values[each.key].labels, {
    managed_by = "opentofu"
    env        = local.secret_values[each.key].version_env
  })

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secrets" {
  for_each = local.secret_ids

  secret      = google_secret_manager_secret.secrets[each.key].id
  secret_data = templatefile(local.secret_values[each.key].value, local.variable_overrides)
}
