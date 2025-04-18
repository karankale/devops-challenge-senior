variable "aws_region" {
  default = "us-east-1"
}

variable "eks_admin_iam_principal_arn" {
  type        = string
  description = "The IAM principal to be granted cluster admin access"
  default     = "arn:aws:iam::079892728706:root"
}
