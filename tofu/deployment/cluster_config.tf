## We're configuring the Helm provider in the module definition, Mostly because we're writing this in a way that we can build multiple clusters with the same module
## But Dang it we cant Dynamically generate Providers in terraform, so we have to do it here. Man Hashicorp, you really need to let us do this. I want to be able to write a module that can create multiple clusters and then have the provider configuration be dynamic based on the cluster that was created.
#
provider "kubernetes" {
  host  = "https://${google_container_cluster.autopilot.endpoint}"
  token = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.autopilot.master_auth[0].cluster_ca_certificate,
  )
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "gke-gcloud-auth-plugin"
  }
}

provider "helm" {
  kubernetes {
    host  = "https://${google_container_cluster.autopilot.endpoint}"
    token = data.google_client_config.current.access_token
    cluster_ca_certificate = base64decode(
      google_container_cluster.autopilot.master_auth[0].cluster_ca_certificate,
    )
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "gke-gcloud-auth-plugin"
    }
  }
}