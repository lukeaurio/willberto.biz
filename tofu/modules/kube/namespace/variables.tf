variable "name" {
  description = "The namespace name."
  type        = string

  validation {
    condition     = length(var.name) <= 63 && can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.name))
    error_message = "name must be a valid Kubernetes DNS-1123 label."
  }
}

variable "labels" {
  description = "Labels applied to the namespace."
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations applied to the namespace."
  type        = map(string)
  default     = {}
}
