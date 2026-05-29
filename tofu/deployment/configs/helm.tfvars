####
# This file contains the variables for the helm module. These variables are used to deploy helm charts to the kubernetes cluster. The values for these variables are defined in the terraform.tfvars file.
####

helm_releases = [
  {
    name          = "nginx"
    repo_url      = "oci://registry-1.docker.io/bitnamicharts"
    chart_name    = "nginx"
    version       = "latest"
    namespace     = "nginx-tofutest"
    values_file   = "helm/nginx/nginx-values.yaml"
    replica_count = 0
    disabled      = true
  },
  {
    name                      = "external-secrets"
    repo_url                  = "https://charts.external-secrets.io/external-secrets/external-secrets"
    chart_name                = "external-secrets"
    version                   = "0.9.0"
    namespace                 = "external-secrets"
    values_file               = "helm/external-secrets/external-secrets-values.yaml"
    create_service_account    = true
    service_account_gcp_roles = ["roles/secretmanager.secretAccessor"]
    replica_count             = 1
  }

]

helm_external_secret_stores = [
  {
    name                 = "cluster-gsm-store"
    namespace            = "external-secrets"
    secret_store_kind    = "ClusterSecretStore"
    service_account_name = "external-secrets-sa"
  }
]

helm_external_secrets = [
  {
    name               = "cloudflare-tunnel-secret"
    namespace          = "flux-cd"
    refresh_interval   = "1h0m0s"
    secret_store_name  = "cluster-gsm-store"
    secret_store_kind  = "ClusterSecretStore"
    target_secret_name = "cloudflare-tunnel-secret"
    creation_policy    = "Owner"
    data = [
      {
        secret_key = "CLOUDFLARE_API_TOKEN"
        remote_key = "cloudflare-api-token"
      }
    ]
  }
]

google_secrets = [
  {
    secret_id = "cloudflare-tunnel-secret"
    value     = "$${cloudflare_token}"
    labels = {
      app = "global"
    }
  }
]