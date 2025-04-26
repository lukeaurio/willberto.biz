# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

# We're configuring the Helm provider in the module definition, Mostly because we're writing this in a way that we can build multiple clusters with the same module
provider "kubernetes" {
  host  = "https://${google_container_cluster.default.endpoint}"
  token = google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.default.master_auth[0].cluster_ca_certificate,
  )
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gke-gcloud-auth-plugin"
  }
}
