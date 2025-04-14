variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "simple-time-eks"
}

variable "container_image" {
  description = "The container image to deploy (with tag)"
  type        = string
}
