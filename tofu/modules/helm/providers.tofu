# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

# Retrieve the cluster endpoint and CA certificate
data "google_container_cluster" "my_cluster" {
  name     = var.kubernetes_cluster_namecluster_name
  project  = var.project
  location = var.region
}


# We're configuring the Helm provider in the module definition, Mostly because we're writing this in a way that we can build multiple clusters with the same module
provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
    )
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "gke-gcloud-auth-plugin"
    }
  }
}