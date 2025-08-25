# Production Environment Configuration
# This file configures the production environment for Opentrons documentation

provider "aws" {
  region = "us-east-2"
}

# Production Documentation S3 Buckets
module "docs_buckets" {
  source = "../modules/docs-buckets"
  
  environment = "production"
  aws_region  = "us-east-2"
  
  enable_versioning = true
  enable_lifecycle_rules = true
  noncurrent_version_expiration_days = 30  # Longer retention for production
  
  tags = {
    Project     = "opentrons-docs"
    Environment = "production"
    Team        = "platform"
    CostCenter  = "engineering"
    ManagedBy   = "terraform"
  }
}

# Outputs for production environment
output "production_bucket_name" {
  description = "Production documentation bucket name"
  value       = module.docs_buckets.production_bucket_name
}

output "production_bucket_arn" {
  description = "Production documentation bucket ARN"
  value       = module.docs_buckets.production_bucket_arn
}

output "production_website_endpoint" {
  description = "Production documentation website endpoint"
  value       = module.docs_buckets.production_website_endpoint
}

output "production_deployment_url" {
  description = "Production documentation deployment URL"
  value       = "https://docs.opentrons.com/"
}

