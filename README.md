# OpenTofu + AWS S3 Tutorial

This repo is a step-by-step tutorial for learning [Open Tofu](www.opentofu.io). At the end of this tutorial, you will be able to create a S3 bucket using Open Tofu.

# Prerequisites

* OpenTofu installed (tofu version OpenTofu v1.10.6 as of this commit)

* AWS CLI installed and configured

* AWS credentials available via:
   * ~/.aws/credentials and AWS_PROFILE, or 
   * AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN (for temporary creds)

# Usage
1. Initialize the project
```bash
tofu init
```
2. Plan the project
```bash
tofu plan -var bucket_name=opentofu-s3-demo
```
3. Apply the project
```bash
tofu apply -var bucket_name=opentofu-s3-demo
```
4. Verify that the bucket was created
```bash
aws s3 ls | grep opentofu-s3-demo
```
5. To destroy the bucket (optional)
```bash
aws s3 rm s3://my-opentofu-demo-bucket --recursive
tofu destroy
```

# State
OpenTofu tracks resources in a state file (terraform.tfstate). These are some of the basic commands:

1. Show State
```
tofu show
tofu state list
tofu state show aws_s3_bucket.demo
```
2. Refresh from cloud
```
tofu plan -refresh-only
tofu apply -refresh-only
```
3. Import an existing bucket
```
tofu import aws_s3_bucket.demo my-existing-bucket
```
4. Move a resource (e.g., if you rename it in code):
```bash
tofu state mv aws_s3_bucket.demo aws_s3_bucket.warehouse
```