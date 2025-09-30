terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.50"
    }
  }
  # Optional: uncomment and configure if you want remote state in S3
  # backend "s3" {}
}

provider "aws" {
  region  = var.aws_region
  # Only use a profile when a non-empty value is provided
  profile = trim(var.aws_profile) != "" ? var.aws_profile : null
}


# --- Core bucket ---
resource "aws_s3_bucket" "demo" {
  bucket = var.bucket_name

  tags = merge({
    Name    = var.bucket_name
    Project = "opentofu-demo"
  }, var.extra_tags)
}

# Block all public access by default
resource "aws_s3_bucket_public_access_block" "demo" {
  bucket                  = aws_s3_bucket.demo.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Object ownership (lets uploaders own their objects)
resource "aws_s3_bucket_ownership_controls" "demo" {
  bucket = aws_s3_bucket.demo.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

# Versioning (toggle)
resource "aws_s3_bucket_versioning" "demo" {
  bucket = aws_s3_bucket.demo.id
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

# Default encryption (AES256 or KMS) — disabled if "none"
resource "aws_s3_bucket_server_side_encryption_configuration" "demo" {
  count  = var.encryption == "none" ? 0 : 1
  bucket = aws_s3_bucket.demo.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.encryption == "aws:kms" ? "aws:kms" : "AES256"
      kms_master_key_id = var.encryption == "aws:kms" ? var.kms_key_arn : null
    }
  }
}

# --- Outputs ---
output "bucket_name"  { value = aws_s3_bucket.demo.bucket }
output "bucket_arn"   { value = aws_s3_bucket.demo.arn }
output "bucket_region" { value = var.aws_region }

