terraform {
    required_version = ">= 1.0.0"

    required_providers {
        google = {
            source  = "opentofu/google"
            version = ">= 6.0.0"
        }
    }
}