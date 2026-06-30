locals {
  project_name_sanitized = lower(var.project_name) #This is to prevent unnecessary recreates from the lower function. 

  root_path = "${path.module}/.."

  variable_overrides = {
    "gcp_project_id"   = var.project_id
    "gcp_project_name" = local.project_name_sanitized
    "ghcr_token"       = var.ghcr_token
  }
}