resource "google_storage_bucket" "this" {

  name                        = var.key
  location                    = var.region
  project                     = var.project
  storage_class               = var.storage_class
  public_access_prevention    = var.public_access_prevention
  uniform_bucket_level_access = var.uniform_bucket_level_access
  versioning {
    enabled = var.versioning
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      condition {
        age = lifecycle_rule.value.age
      }
      action {
        type = lifecycle_rule.value.type
      }
    }
  }
}