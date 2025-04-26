module "google_storage_bucket" {
    source = "../modules/google/bucket"
    
    for_each = var.buckets

    name                        = each.key
    location                    = var.region
    project                     = var.project_id
    storage_class               = each.value.storage_class
    public_access_prevention    = each.value.public_access_prevention
    uniform_bucket_level_access = each.value.uniform_bucket_level_access
    lifecycle_rules             = each.value.lifecycle_rules
}