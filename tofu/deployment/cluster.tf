resource "google_container_cluster" "autopilot" {
  name = lower("${var.project_name}-auto-cluster")

  location                 = var.region
  enable_autopilot         = true
  enable_l4_ilb_subsetting = true


  network    = google_compute_network.default.id
  subnetwork = google_compute_subnetwork.default.id

  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = google_service_account.cluster_autopilot.email
      oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    }
  }

  ip_allocation_policy {
    stack_type                    = "IPV4_IPV6"
    services_secondary_range_name = google_compute_subnetwork.default.secondary_ip_range[0].range_name
    cluster_secondary_range_name  = google_compute_subnetwork.default.secondary_ip_range[1].range_name
  }

  deletion_protection = false
  lifecycle {
    ignore_changes = [network, subnetwork] # Ignore changes to network and subnetwork to prevent unnecessary updates
  }
}
removed {
  from = google_container_cluster.default
  lifecycle {
    destroy = false
  }
}