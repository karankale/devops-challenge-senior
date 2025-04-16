output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "k8s_app_url" {
  value = module.k8s_app.app_url
}