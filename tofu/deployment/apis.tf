locals {
  required_google_apis = toset([
    "iamcredentials.googleapis.com",
    "secretmanager.googleapis.com",
  ])
}

resource "google_project_service" "required" {
  for_each = local.required_google_apis

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}
