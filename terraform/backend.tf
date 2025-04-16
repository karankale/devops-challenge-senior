terraform {
  backend "s3" {
    bucket         = "terraform-state-kkco-2025"
    key            = "simple-time-service/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}