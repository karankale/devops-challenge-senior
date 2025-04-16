module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.35.0"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.32"

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true
  
  subnet_ids = var.private_subnet_ids
  vpc_id     = var.vpc_id
  
  cluster_addons = {
  coredns    = {}
  kube-proxy = {}
  vpc-cni    = {}
  }

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 3
      desired_size = 2
      instance_types = ["t3.small"]
    }
  }
}

