provider "google" {
  project                         = var.project_id
  region                          = var.region
  zone                            = var.zone
  add_terraform_attribution_label = true
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0" # Should I bump this up? teh 3.0 release is coming soon!
    }
  }

  #backend "local" { 
  #  path = "configs/willbertobiz.tfstate"
  #}
  backend "gcs" {
    #bucket = Use the bucket name from a backend.tfvars file or pass it in with an environment variable like in .github/actions/tofu_plan_lint/action.yml
    #prefix = #Make this whatever hugh like! but like above you need to pass it in with an environment variable or a backend.tfvars file
  }
}


provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "random" {
}

# Retrieve the cluster endpoint and CA certificate
data "google_container_cluster" "my_cluster" {
  name     = google_container_cluster.default.name
  project  = var.project_id
  location = var.region
}

data "google_client_config" "current" {} # Gotta define this for the use of the Helm and Kubernetes providers

# We're configuring the Helm provider to use the GKE cluster we just made
provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.my_cluster.endpoint}"
    token = data.google_client_config.current.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate,
    )
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "gke-gcloud-auth-plugin"
    }
  }
}