resource "aws_iam_role_policy_attachment" "eks_node_elb" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = module.eks.node_group_iam_role_name
}

resource "aws_iam_role_policy_attachment" "eks_node_ecr" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = module.eks.node_group_iam_role_name
}

resource "aws_eks_access_entry" "admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = var.eks_admin_iam_principal_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin_policy" {
  cluster_name       = module.eks.cluster_name
  policy_arn         = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn      = aws_eks_access_entry.admin.principal_arn
  access_scope {
    type = "cluster"
  }
}

resource "null_resource" "wait_for_eks" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for EKS cluster to become ready..."
      for i in {1..60}; do
        aws eks describe-cluster --name ${module.eks.cluster_name} --region ${var.aws_region} \
        --query 'cluster.status' --output text | grep -q ACTIVE && break || sleep 10
      done
    EOT
    interpreter = ["bash", "-c"]
  }
}

module "vpc" {
  source = "./modules/vpc"
}

module "eks" {
  source = "./modules/eks"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
}

module "k8s_app" {
  source = "./modules/k8s_app"
  depends_on = [null_resource.wait_for_eks]  
  cluster_name = module.eks.cluster_name
  kubeconfig   = module.eks.kubeconfig
}
