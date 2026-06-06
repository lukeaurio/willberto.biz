resource "cloudflare_zero_trust_tunnel_cloudflared" "example_zero_trust_tunnel_cloudflared" {
  name       = "${var.project_name}-tunnel"
  config_src = "cloudflare"
}