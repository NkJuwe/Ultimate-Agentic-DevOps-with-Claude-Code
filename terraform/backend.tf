# Terraform State Backend Configuration
#
# IMPORTANT: Uncomment this after creating your Terraform state bucket.
#
# Steps to set up remote state:
# 1. First run: `terraform init` (without backend config)
# 2. Run: `terraform apply` (creates S3 bucket, CloudFront, etc.)
# 3. Create a state bucket manually or via separate Terraform:
#    aws s3 mb s3://terraform-state-${ACCOUNT_ID}-${REGION}
# 4. Enable versioning on the state bucket:
#    aws s3api put-bucket-versioning \
#      --bucket terraform-state-${ACCOUNT_ID}-${REGION} \
#      --versioning-configuration Status=Enabled
# 5. Uncomment the backend block below
# 6. Run: `terraform init -migrate-state`
#
# This will migrate your local state to the S3 backend.

# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-ACCOUNT_ID-REGION"
#     key            = "portfolio-site/terraform.tfstate"
#     region         = "ap-south-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }
