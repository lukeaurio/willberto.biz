variable "cloudflare_api_token" {
    description = "API token for Cloudflare authentication"
    type        = string
    sensitive   = true
}

variable "zone_id" {
    description = "Cloudflare Zone ID"
    type        = string
}

variable "domain_name" {
    description = "The domain name managed in Cloudflare"
    type        = string
}

variable "dns_records" {
    description = "List of DNS records to create"
    type = list(object({
        name    = string
        type    = string
        value   = string
        ttl     = optional(number, 1)
        proxied = optional(bool, false)
    }))
    default = []
}

variable "enable_firewall_rules" {
    description = "Enable Cloudflare firewall rules"
    type        = bool
    default     = false
}

variable "firewall_rules" {
    description = "List of firewall rules to apply"
    type = list(object({
        description = string
        action      = string
        filter      = object({
            expression = string
        })
        priority = optional(number)
    }))
    default = []
}

variable "cloudflared_helm_variables" {
    description = "Cloudflared helm variables"
    type = object({
        service_name         = string
        helm_chart_name      = string
        helm_repository_url  = string
        helm_chart_version   = string
        helm_value_file      = string
        replica_count        = number
        kubernetes_cluster_name = string
        project             = string
        region              = string
    })
}