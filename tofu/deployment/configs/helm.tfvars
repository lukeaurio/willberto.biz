####
# This file contains the variables for the helm module. These variables are used to deploy helm charts to the kubernetes cluster. The values for these variables are defined in the terraform.tfvars file.
####

helm_releases = [
  {
    name          = "nginx"
    repo_url      = "https://charts.bitnami.com/bitnami"
    chart_name    = "nginx"
    version       = "4.0.6"
    namespace     = "nginx-tofutest"
    values_file   = "helm/nginx/nginx-values.yaml"
    replica_count = 0
  }
]