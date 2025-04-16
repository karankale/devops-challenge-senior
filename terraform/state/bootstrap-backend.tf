provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "terraform-state-kkco-2025"
  force_destroy = false
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "state_access_policy" {
  bucket = aws_s3_bucket.tf_state.id
  policy = jsonencode({"Version": "2012-10-17", "Statement": [{"Sid": "AllowTerraformStateAccess", "Effect": "Allow", "Principal": {"AWS": "arn:aws:iam::079892728706:root"}, "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:ListBucket"], "Resource": ["arn:aws:s3:::terraform-state-kkco-2025", "arn:aws:s3:::terraform-state-kkco-2025/simple-time-service/*"]}]})
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
