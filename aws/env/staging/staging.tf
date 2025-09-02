# Staging Environment Configuration
# This file configures the staging environment for Opentrons documentation

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Local values for consistent tagging
locals {
  common_tags = {
    Environment = var.environment
    environment = var.environment
    ou          = "robotics"
    ManagedBy   = "terraform"
    Project     = "opentrons-docs"
  }
}

# S3 Bucket using the docs-buckets module
module "docs_bucket" {
  source = "../../modules/docs-buckets"

  bucket_name                           = var.mkdocs_bucket_name
  environment                          = var.environment
  enable_public_access                 = false  # CloudFront only access
  enable_versioning                    = var.enable_versioning
  enable_lifecycle_rules               = var.enable_lifecycle_rules
  noncurrent_version_expiration_days   = var.noncurrent_version_expiration_days
  tags                                 = local.common_tags
}

# Labware Library S3 Bucket using the docs-buckets module
module "labware_library_bucket" {
  source = "../../modules/docs-buckets"

  bucket_name                           = var.labware_library_bucket_name
  environment                          = var.environment
  enable_public_access                 = false  # CloudFront only access
  enable_versioning                    = var.enable_versioning
  enable_lifecycle_rules               = var.enable_lifecycle_rules
  noncurrent_version_expiration_days   = var.noncurrent_version_expiration_days
  tags                                 = merge(local.common_tags, {
    Project = "opentrons-labware-library"
  })
}

# CloudFront Distribution using the cloudfront-distribution module
module "cloudfront_distribution" {
  source = "../../modules/cloudfront-distribution"

  environment              = var.environment
  enabled                  = true
  is_ipv6_enabled          = true
  comment                  = "Staging documentation distribution"
  default_root_object      = "index.html"
  price_class              = "PriceClass_100"  # Use only North America and Europe
  aliases                  = [var.domain_name]
  
  # Origin configuration
  origin_domain_name       = "${var.mkdocs_bucket_name}.s3.${var.aws_region}.amazonaws.com"
  origin_id                = "${var.mkdocs_bucket_name}-origin"
  custom_user_agent        = "Opentrons-Docs-Staging"
  
  # S3 bucket configuration
  s3_bucket_id             = module.docs_bucket.bucket_name
  s3_bucket_arn            = module.docs_bucket.bucket_arn
  
  # Cache behavior
  allowed_methods          = ["GET", "HEAD"]
  cached_methods           = ["GET", "HEAD"]
  forward_query_string     = false
  forward_cookies          = "none"
  viewer_protocol_policy   = "redirect-to-https"
  min_ttl                  = 0
  default_ttl              = 0
  max_ttl                  = 0
  compress                 = true
  
  # Function associations
  function_associations = [
    {
      event_type   = "viewer-request"
      function_arn = var.cloudfront_function_arn
    }
  ]
  
  # Custom error responses
  custom_error_responses = [
    {
      error_code            = 404
      response_code         = 404
      response_page_path    = "/404.html"
      error_caching_min_ttl = 10
    }
  ]
  
  # Restrictions
  geo_restriction_type     = "none"
  geo_restriction_locations = []
  
  # SSL/TLS configuration
  use_default_certificate  = false
  acm_certificate_arn      = var.acm_certificate_arn
  ssl_support_method       = "sni-only"
  minimum_protocol_version = "TLSv1.2_2021"
  
  # WAF configuration (not configured for staging)
  web_acl_id = var.web_acl_id
  
  tags = merge(local.common_tags, {
    Name = "staging.docs.opentrons.com"
  })
}



# Outputs for staging environment
output "staging_bucket_name" {
  description = "Staging documentation bucket name"
  value       = module.docs_bucket.bucket_name
}

output "staging_bucket_arn" {
  description = "Staging documentation bucket ARN"
  value       = module.docs_bucket.bucket_arn
}

output "staging_bucket_id" {
  description = "Staging documentation bucket ID"
  value       = module.docs_bucket.bucket_name
}

output "staging_labware_library_bucket_name" {
  description = "Staging labware library bucket name"
  value       = module.labware_library_bucket.bucket_name
}

output "staging_labware_library_bucket_arn" {
  description = "Staging labware library bucket ARN"
  value       = module.labware_library_bucket.bucket_arn
}

output "staging_cloudfront_domain" {
  description = "Staging CloudFront distribution domain"
  value       = module.cloudfront_distribution.distribution_domain_name
}

output "staging_cloudfront_id" {
  description = "Staging CloudFront distribution ID"
  value       = module.cloudfront_distribution.distribution_id
}

output "staging_cloudfront_arn" {
  description = "Staging CloudFront distribution ARN"
  value       = module.cloudfront_distribution.distribution_arn
}

output "staging_deployment_url" {
  description = "Staging documentation deployment URL"
  value       = "https://${var.domain_name}/"
}

output "staging_origin_access_control_id" {
  description = "Staging CloudFront origin access control ID"
  value       = module.cloudfront_distribution.origin_access_control_id
}

