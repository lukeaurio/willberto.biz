resource "google_service_account" "cluster_autopilot" {
  account_id   = "cluster-autopilot"
  display_name = "Cluster Autopilot Service Account"
}

resource "google_project_iam_member" "cluster_autopilot_permission" {
  for_each = toset([
    "roles/container.defaultNodeServiceAccount",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/storage.objectViewer",
    "roles/storage.objectAdmin"
  ])
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.cluster_autopilot.email}"
}
