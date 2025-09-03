# Sandbox Environment Configuration
# This file configures the sandbox environment for Opentrons documentation

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

  bucket_name                           = var.bucket_name
  environment                          = var.environment
  enable_public_access                 = false  # CloudFront only access
  enable_versioning                    = var.enable_versioning
  enable_lifecycle_rules               = var.enable_lifecycle_rules
  noncurrent_version_expiration_days   = var.noncurrent_version_expiration_days
  tags                                 = local.common_tags
}

# CloudFront Distribution using the cloudfront-distribution module
module "cloudfront_distribution" {
  source = "../../modules/cloudfront-distribution"

  environment              = var.environment
  project                  = "mkdocs"
  enabled                  = true
  is_ipv6_enabled          = true
  comment                  = "Sandbox documentation distribution"
  default_root_object      = "index.html"
  price_class              = "PriceClass_100"  # Use only North America and Europe
  # aliases                  = [var.domain_name]  # Temporarily commented out to avoid CNAME conflict
  
  # Origin configuration
  origin_domain_name       = "${var.bucket_name}.s3.${var.aws_region}.amazonaws.com"
  origin_id                = "${var.bucket_name}-origin"
  custom_user_agent        = "Opentrons-Docs-Sandbox"
  
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
      response_page_path    = "/edge/404.html"
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
  
  # WAF configuration (not configured for sandbox)
  web_acl_id = var.web_acl_id
  
  tags = merge(local.common_tags, {
    Name = "sandbox.docs"
  })
}



