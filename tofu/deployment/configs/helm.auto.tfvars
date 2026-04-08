helm_releases = {
  nginx_ingress = {
    name          = "nginx"
    repo_url      = "https://charts.bitnami.com/bitnami"
    chart_name     = "nginx"
    version        = "4.0.6"
    namespace      = "nginx-tofutest"
    values_file    = "${path.module}/../helm/nginx/nginx-values.yaml"
    replica_count  = 1
  }
}