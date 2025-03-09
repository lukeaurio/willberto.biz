provider "google" {
  project = var.project_id
  region  = var.region
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
    bucket      = "willberto_tfstates" #<your Bucket here!>
    prefix      = "willberto_site"     #<Make this whatever hugh like!>
  }
}
