# Sandbox Environment Configuration
# This file configures the sandbox environment for Opentrons documentation

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

# Sandbox Documentation S3 Buckets
module "docs_buckets" {
  source = "../../modules/docs-buckets"
  
  environment = "sandbox"
  aws_region  = "us-east-2"
  
  enable_versioning = true
  enable_lifecycle_rules = true
  noncurrent_version_expiration_days = 7  # Short retention for sandbox
  
  tags = {
    Project     = "opentrons-docs"
    Environment = "sandbox"
    Team        = "platform"
    CostCenter  = "engineering"
    ManagedBy   = "terraform"
  }
}

# Outputs for sandbox environment
output "sandbox_bucket_name" {
  description = "Sandbox documentation bucket name"
  value       = module.docs_buckets.sandbox_bucket_name
}

output "sandbox_bucket_arn" {
  description = "Sandbox documentation bucket ARN"
  value       = module.docs_buckets.sandbox_bucket_arn
}

output "sandbox_website_endpoint" {
  description = "Sandbox documentation website endpoint"
  value       = module.docs_buckets.sandbox_website_endpoint
}

output "sandbox_deployment_url" {
  description = "Sandbox documentation deployment URL"
  value       = "http://sandbox.docs.s3-website.us-east-2.amazonaws.com/"
}

