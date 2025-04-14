terraform {
#   backend "s3" {
#     bucket         = "your-tf-state-bucket-name"
#     key            = "simple-time-service/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
  backend "local" {
    
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source       = "./modules/vpc"
  cluster_name = var.cluster_name
}

module "eks" {
  source        = "./modules/eks"
  cluster_name  = var.cluster_name
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.vpc.private_subnets
}

module "k8s_app" {
  source           = "./modules/k8s-app"
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_ca       = module.eks.cluster_ca
  cluster_token    = module.eks.cluster_token
  container_image  = var.container_image
}

module "alb_ingress" {
  source           = "./modules/alb-ingress"
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_ca       = module.eks.cluster_ca
  cluster_token    = module.eks.cluster_token
  service_name     = module.k8s_app.service_name
}
