provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint #data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(var.cluser_certificate) #data.aws_eks_cluster.cluster.certificate_authority.0.data
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name] #data.aws_eks_cluster.cluster.name
      command     = "aws"
    }
  }
}
