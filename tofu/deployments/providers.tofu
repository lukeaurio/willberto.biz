provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0"
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
