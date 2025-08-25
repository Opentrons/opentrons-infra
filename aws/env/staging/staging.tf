# Staging Environment Configuration
# This file configures the staging environment for Opentrons documentation

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

# Staging Documentation S3 Buckets
module "docs_buckets" {
  source = "../modules/docs-buckets"
  
  environment = "staging"
  aws_region  = "us-east-2"
  
  enable_versioning = true
  enable_lifecycle_rules = true
  noncurrent_version_expiration_days = 14  # Medium retention for staging
  
  tags = {
    Project     = "opentrons-docs"
    Environment = "staging"
    Team        = "platform"
    CostCenter  = "engineering"
    ManagedBy   = "terraform"
  }
}

# Outputs for staging environment
output "staging_bucket_name" {
  description = "Staging documentation bucket name"
  value       = module.docs_buckets.staging_bucket_name
}

output "staging_bucket_arn" {
  description = "Staging documentation bucket ARN"
  value       = module.docs_buckets.staging_bucket_arn
}

output "staging_website_endpoint" {
  description = "Staging documentation website endpoint"
  value       = module.docs_buckets.staging_website_endpoint
}

output "staging_deployment_url" {
  description = "Staging documentation deployment URL"
  value       = "https://staging.docs.opentrons.com/"
}

