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

# S3 Bucket for MkDocs documentation using the docs-buckets module
module "docs_bucket" {
  source = "../../modules/docs-buckets"

  bucket_name                           = var.bucket_name
  environment                          = var.environment
  enable_public_access                 = false  # CloudFront only access
  enable_versioning                    = var.enable_versioning
  enable_lifecycle_rules               = var.enable_lifecycle_rules
  noncurrent_version_expiration_days   = var.noncurrent_version_expiration_days
  tags                                 = merge(local.common_tags, {
    Project = "opentrons-docs"
  })
}

# S3 Bucket for Labware Library using the docs-buckets module
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

# S3 Bucket for Protocol Designer using the docs-buckets module
module "protocol_designer_bucket" {
  source = "../../modules/docs-buckets"

  bucket_name                           = var.protocol_designer_bucket_name
  environment                          = var.environment
  enable_public_access                 = false  # CloudFront only access
  enable_versioning                    = var.enable_versioning
  enable_lifecycle_rules               = var.enable_lifecycle_rules
  noncurrent_version_expiration_days   = var.noncurrent_version_expiration_days
  tags                                 = merge(local.common_tags, {
    Project = "opentrons-protocol-designer"
  })
}

# CloudFront Distribution for MkDocs using the cloudfront-distribution module
module "docs_cloudfront_distribution" {
  source = "../../modules/cloudfront-distribution"

  environment              = var.environment
  project                  = "mkdocs"
  enabled                  = true
  is_ipv6_enabled          = true
  comment                  = ""  # Match existing empty comment
  default_root_object      = "index.html"
  price_class              = "PriceClass_100"  # Use only North America and Europe
  aliases                  = [var.domain_name]  # Match existing alias
  
  origin_domain_name       = "${var.bucket_name}.s3.${var.aws_region}.amazonaws.com"
  origin_id                = "${var.bucket_name}.s3.${var.aws_region}.amazonaws.com-mfebxihrkqr"  # Match existing origin ID
  custom_user_agent        = ""  # No custom user agent to match existing
  
  # S3 bucket configuration
  s3_bucket_id             = module.docs_bucket.bucket_name
  s3_bucket_arn            = module.docs_bucket.bucket_arn
  
  # Cache behavior - caching disabled for sandbox
  allowed_methods          = ["GET", "HEAD"]
  cached_methods           = ["GET", "HEAD"]
  viewer_protocol_policy   = "redirect-to-https"
  compress                 = true
  forward_query_string     = true   # Disable caching by forwarding query strings
  forward_cookies          = "all"  # Disable caching by forwarding all cookies
  min_ttl                  = 0      # Disable caching
  default_ttl              = 0      # Disable caching
  max_ttl                  = 0      # Disable caching
  
  function_associations = [
    {
      event_type   = "viewer-request"
      function_arn = "arn:aws:cloudfront::043748923082:function/sandboxRedirect"  # Match existing function
    }
  ]
  
  # No custom error responses to match existing
  
  # Restrictions
  geo_restriction_type     = "none"
  geo_restriction_locations = []
  
  # SSL/TLS configuration - use existing ACM certificate
  use_default_certificate  = false
  acm_certificate_arn      = "arn:aws:acm:us-east-1:043748923082:certificate/fefdb546-2e50-46fc-8781-efd96521e779"
  ssl_support_method       = "sni-only"
  minimum_protocol_version = "TLSv1.2_2021"
  
  # WAF configuration (not configured for sandbox)
  web_acl_id = var.web_acl_id
  
  # OAC configuration to match existing
  origin_access_control_name = "oac-sandbox.docs.s3.us-east-2.amazonaws.com-mfebxx2y3dv"
  origin_access_control_description = "Created by CloudFront"
  
  # Tags to match existing distribution
  tags = {
    Name = "sandbox.docs.opentrons.com"
  }
  
  depends_on = [module.docs_bucket]
}

# CloudFront Distribution for Labware Library using the cloudfront-distribution module
module "labware_library_cloudfront_distribution" {
  source = "../../modules/cloudfront-distribution"

  environment              = var.environment
  project                  = "labware"
  enabled                  = true
  is_ipv6_enabled          = true
  comment                  = "Sandbox labware library distribution"
  default_root_object      = "index.html"
  price_class              = "PriceClass_100"  # Use only North America and Europe
  # No aliases - use default CloudFront domain
  
  origin_domain_name       = "${var.labware_library_bucket_name}.s3.${var.aws_region}.amazonaws.com"
  origin_id                = "${var.labware_library_bucket_name}-origin"
  custom_user_agent        = "Opentrons-Labware-Library-Sandbox"
  
  # S3 bucket configuration
  s3_bucket_id             = module.labware_library_bucket.bucket_name
  s3_bucket_arn            = module.labware_library_bucket.bucket_arn
  
  # Cache behavior - caching disabled for sandbox
  allowed_methods          = ["GET", "HEAD"]
  cached_methods           = ["GET", "HEAD"]
  forward_query_string     = true
  forward_cookies          = "all"
  viewer_protocol_policy   = "redirect-to-https"
  min_ttl                  = 0
  default_ttl              = 0
  max_ttl                  = 0
  compress                 = true
  
  function_associations = [
    {
      event_type   = "viewer-request"
      function_arn = var.cloudfront_function_arn
    }
  ]
  
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
  
  # SSL/TLS configuration - use default CloudFront certificate
  use_default_certificate  = true
  ssl_support_method       = "sni-only"
  minimum_protocol_version = "TLSv1.2_2021"
  
  # WAF configuration (not configured for sandbox)
  web_acl_id = var.web_acl_id
  
  tags = merge(local.common_tags, {
    Name = "sandbox-labware"
  })
  
  depends_on = [module.labware_library_bucket]
}




