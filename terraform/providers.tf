provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = module.eks.kubeconfig["endpoint"]
  cluster_ca_certificate = base64decode(module.eks.kubeconfig["certificate_authority_data"])

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_name
    ]
  }
}