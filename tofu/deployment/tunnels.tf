resource "cloudflare_zero_trust_tunnel_cloudflared" "ingress_tunnel" {
  name       = "${var.project_name}-tunnel"
  account_id = var.cloudflare_account_id
  config_src = "cloudflare"
}