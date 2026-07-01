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
    repo_url                  = "https://charts.external-secrets.io"
    chart_name                = "external-secrets"
    version                   = "latest"
    namespace                 = "external-secrets"
    values_file               = "helm/external-secrets/external-secrets-values.yaml"
    create_service_account    = true
    service_account_gcp_roles = ["roles/secretmanager.secretAccessor"]
    replica_count             = 1
  },
  {
    name                   = "cloudflare-ingress"
    repo_url               = "https://helm.strrl.dev"
    chart_name             = "cloudflare-tunnel-ingress-controller"
    version                = "latest"
    namespace              = "cloudflare-ingress"
    values_file            = "helm/cloudflare-ingress/values.yaml"
    create_namespace       = false
    create_service_account = true
    replica_count          = 1
    timeout                = 900
    uses_external_secret   = true
  },
  {
    name                   = "hugoblog"
    repo_url               = "https://lukeaurio.github.io/hugoblog-chart"
    chart_name             = "hugoblog"
    version                = "latest"
    namespace              = "hugoblog"
    values_file            = "helm/hugoblog/values.yaml"
    create_namespace       = false
    create_service_account = true
    replica_count          = 1
    uses_external_secret   = true
    uses_cf_ingress        = true
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
    namespace          = "cloudflare-ingress"
    refresh_interval   = "0h0m10s"
    secret_store_name  = "cluster-gsm-store"
    secret_store_kind  = "ClusterSecretStore"
    target_secret_name = "cloudflare-api-token"
    creation_policy    = "Owner"
    data = [
      {
        secret_key = "accountid"
        remote_key = "cloudflare-api-token"
        property   = "account_id"
      },
      {
        secret_key = "apitoken"
        remote_key = "cloudflare-api-token"
        property   = "api_token"
      },
      {
        secret_key = "tunnelid"
        remote_key = "cloudflare-api-token"
        property   = "tunnel_id"
      }
    ]
  },
  {
    name               = "ghcr-token-secret"
    namespace          = "hugoblog"
    refresh_interval   = "0h0m10s"
    secret_type        = "docker_registry"
    secret_store_name  = "cluster-gsm-store"
    secret_store_kind  = "ClusterSecretStore"
    target_secret_name = "ghcr-token"
    creation_policy    = "Owner"
    data = [
      {
        secret_key = "dockerconfig"
        remote_key = "ghcr-token"
      }
    ]
  }
]

google_secrets = [
  {
    secret_id = "ghcr-token"
    value = {
      auths = {
        "ghcr.io" = {
          auth = "$${ghcr_token}"
        }
      }
    }
  }
]
