resource "random_password" "tunnel_secret" {
  length = 64
  lifecycle {
    create_before_destroy = true
    replace_triggered_by  = [var.cloudflared_helm_variables]
  }
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "this" {
  account_id    = var.cloudflare_account_id
  name          = "${var.service_name}-tunnel"
  tunnel_secret = base64sha256(random_password.tunnel_secret.result)
  config_src    = "cloudflare"
  metadata {
    owner = "terraform"
  }
}

resource "cloudflare_dns_record" "this" {
  zone_id = var.cloudflare_zone_id
  name    = "${var.service_name}.${var.cf_root_domain}"
  content = cloudflare_zero_trust_tunnel_cloudflared.this.cname
  value   = cloudflare_zero_trust_tunnel_cloudflared.this.id
  type    = "CNAME"
  ttl     = 1
  tags    = ["terraform", "kubernetes", "${var.service_name}"]
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "this" {
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.this.id
  account_id = var.cloudflare_account_id
  config {
    ingress_rule {
      hostname = cloudflare_record.this.hostname
      service  = "http://httpbin:8080" # Change this to be the Kubernetes service that I'm making internal
      origin_request {
        connect_timeout = "2m0s"
      }
    }
    ingress_rule {
      service = "http_status:404"
    }
  }
}

module "helm" {
  source     = "github.com:lukeaurio/willberto.biz.git//modules/helm"
  depends_on = [cloudflare_zero_trust_tunnel_cloudflared.example_zero_trust_tunnel_cloudflared]

  helm_chart_name         = "${var.service_name}-tunnel-kube"
  helm_namespace          = var.helm_namespace
  helm_repository_url     = var.helm_repository_url
  helm_chart_version      = var.helm_chart_version
  helm_value_file         = var.helm_value_file
  replica_count           = var.replica_count
  kubernetes_cluster_name = var.kubernetes_cluster_name
  project                 = var.project
  region                  = var.region
}