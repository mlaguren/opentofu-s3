terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.50"
    }
  }
}

# main.tf
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_name

  tags = {
    Name    = var.bucket_name
    Project = "opentofu-demo"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.demo.bucket
}
