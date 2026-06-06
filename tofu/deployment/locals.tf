locals {
  project_name_sanitized = lower(var.project_name) #This is to prevent unnecessary recreates from the lower function. 

  root_path = "${path.module}/.."

  variable_overrides = {
    "gcp_project_id" = var.project_id
  }
}