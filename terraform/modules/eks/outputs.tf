output "cluster_name" {
  value = module.eks.cluster_name
}

output "kubeconfig" {
  value = {
    endpoint                   = module.eks.cluster_endpoint
    certificate_authority_data = module.eks.cluster_certificate_authority_data
  }
}

output "node_group_iam_role_name" {
  value = module.eks.eks_managed_node_groups["default"].iam_role_name
}
