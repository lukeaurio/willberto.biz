resource "kubernetes_manifest" "this" {
  manifest = {
    apiVersion = "external-secrets.io/v1"
    kind       = "ExternalSecret"
    metadata = merge(
      {
        name      = var.name
        namespace = var.namespace
      },
      length(var.resource_labels) > 0 ? { labels = var.resource_labels } : {},
      length(var.resource_annotations) > 0 ? { annotations = var.resource_annotations } : {},
    )
    spec = {
      refreshInterval = var.refresh_interval
      secretStoreRef = {
        name = var.secret_store_name
        kind = var.secret_store_kind
      }
      target = merge(
        {
          name           = var.target_secret_name
          creationPolicy = var.creation_policy
        },
        var.secret_type == "docker_registry" ? {
          template = {
            type          = "kubernetes.io/dockerconfigjson"
            engineVersion = "v2"
            data = {
              ".dockerconfigjson" = "{{ .dockerconfig | toString }}"
            }
          }
        } : {}
      )
      data = [
        for item in var.data : merge(
          {
            secretKey = item.secret_key
            remoteRef = merge(
              {
                key = item.remote_key
              },
              item.version != null ? { version = item.version } : {},
              item.property != null ? { property = item.property } : {}
            )
          }
        )
      ]
    }
  }
}
