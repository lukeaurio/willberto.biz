resource "cloudflare_zero_trust_tunnel_cloudflared" "ingress_tunnel" {
  name       = "${var.project_name}-tunnel"
  config_src = "cloudflare"
}