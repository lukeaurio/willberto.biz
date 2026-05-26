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
    repo_url                  = "oci://ghcr.io/external-secrets/external-secrets"
    chart_name                = "external-secrets"
    version                   = "0.9.0"
    namespace                 = "external-secrets"
    values_file               = "helm/external-secrets/external-secrets-values.yaml"
    create_service_account    = true
    service_account_gcp_roles = ["roles/secretmanager.secretAccessor"]
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
    name               = "example-app-secret"
    namespace          = "nginx-tofutest"
    refresh_interval   = "1h0m0s"
    secret_store_name  = "cluster-gsm-store"
    secret_store_kind  = "ClusterSecretStore"
    target_secret_name = "example-app-secret"
    creation_policy    = "Owner"
    data = [
      {
        secret_key = "API_TOKEN"
        remote_key = "example-app-api-token"
      }
    ]
  }
]

example_google_secrets = [
  {
    secret_id = "example-app-api-token"
    value     = "replace-with-real-value"
    labels = {
      app = "example"
    }
  }
]