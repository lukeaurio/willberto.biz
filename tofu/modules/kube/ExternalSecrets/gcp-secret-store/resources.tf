
resource "kubernetes_manifest" "this" {
  manifest = {
    apiVersion = "external-secrets.io/v1"
    kind       = var.secret_store_kind
    metadata = merge(
      {
        name = var.secret_store_name
      },
      var.secret_store_kind == "SecretStore" ? { namespace = var.namespace } : {},
    )
    spec = {
      provider = {
        gcpsm = {
          projectID = var.gcp_project_id
          auth = {
            workloadIdentity = merge(
              {
                serviceAccountRef = merge(
                  {
                    name = var.service_account_name
                  },
                  var.secret_store_kind == "ClusterSecretStore" ? { namespace = var.namespace } : {},
                )
              }
            )
          }
        }
      }
    }
  }
}