variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
  validation {
    condition = can(regex("^[a-z0-9]([a-z0-9.-]{1,61})[a-z0-9]$", var.bucket_name))
    error_message = "Bucket names must be 3-63 chars, lowercase letters, numbers, dots or hyphens, no leading/trailing dot or hyphen."
  }
}

variable "aws_profile" {
  description = "Named AWS profile from ~/.aws/credentials (leave empty in CI)"
  type        = string
  default     = ""   # MUST be empty in CI
}

variable "enable_versioning" {
  description = "Enable S3 versioning"
  type        = bool
  default     = true
}

variable "encryption" {
  description = "Default encryption: AES256 | aws:kms | none"
  type        = string
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "aws:kms", "none"], var.encryption)
    error_message = "Use AES256, aws:kms, or none."
  }
}

variable "kms_key_arn" {
  description = "KMS key ARN (required if encryption=aws:kms)"
  type        = string
  default     = ""
}

variable "extra_tags" {
  description = "Additional tags to merge with defaults"
  type        = map(string)
  default     = {}
}

# Guard: if encryption is KMS, kms_key_arn must be provided
locals {
  _kms_guard = var.encryption != "aws:kms" || (var.encryption == "aws:kms" && trim(var.kms_key_arn) != "")
}


