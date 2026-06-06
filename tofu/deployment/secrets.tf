locals {
  secret_ids    = nonsensitive(toset(compact([for secret in concat(var.google_secrets, local.tfDependentSecrets) : !secret.disabled ? nonsensitive(secret.secret_id) : null])))
  secret_values = { for secret in concat(var.google_secrets, local.tfDependentSecrets) : secret.secret_id => secret }
  tfDependentSecrets = [
    {
      secret_id = "cloudflare-api-token"
      value = jsonencode({
        api_token  = var.cloudflare_api_token
        tunnel_id  = try(cloudflare_zero_trust_tunnel_cloudflared.example_zero_trust_tunnel_cloudflared.id, null)
        account_id = try(cloudflare_zero_trust_tunnel_cloudflared.example_zero_trust_tunnel_cloudflared.account_id, null)
      })
      labels = {
        app = "global"
      }
    }
  ]
}


resource "google_secret_manager_secret" "secrets" {
  for_each  = local.secret_ids
  project   = var.project_id
  secret_id = "${var.project_name}-${each.key}"

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
  secret_data = templatestring(local.secret_values[each.key].value, local.variable_overrides)
}
