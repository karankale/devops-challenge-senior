variable "cluster_endpoint" {
  description = "EKS cluster endpoint"
  type        = string
}

variable "cluster_ca" {
  description = "EKS cluster certificate authority data"
  type        = string
}

variable "cluster_token" {
  description = "EKS cluster authentication token"
  type        = string
}

variable "container_image" {
  description = "Container image to deploy"
  type        = string
}