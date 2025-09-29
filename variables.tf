variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}

# variables.tf
variable "aws_profile" {
  description = "Named AWS profile from ~/.aws/credentials"
  type        = string
  default     = "default"
}
