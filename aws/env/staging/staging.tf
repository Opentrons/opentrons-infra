# Staging Environment Configuration
# This file configures the staging environment for Opentrons documentation

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
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

# Data source to reference the main docs zone from production
data "aws_route53_zone" "mkdocs" {
  name = "docs.opentrons.com"
}

# ACM Certificate for MkDocs
module "mkdocs_certificate" {
  source = "../../modules/acm-certificate"

  environment    = var.environment
  domain_name    = var.domain_name
  route53_zone_id = data.aws_route53_zone.mkdocs.zone_id
  create_validation = false  # Disable validation for existing certificate
  tags = merge(local.common_tags, {
    Project = "opentrons-docs"
  })
  
  providers = {
    aws = aws.us_east_1
  }
  
  depends_on = [data.aws_route53_zone.mkdocs]
}

# Hosted Zone for Labware Library (delegated subdomain)
# Data source to reference the main labware zone from production
data "aws_route53_zone" "labware_library" {
  name = "labware.opentrons.com"
}

# ACM Certificate for Labware Library
module "labware_certificate" {
  source = "../../modules/acm-certificate"

  environment    = var.environment
  domain_name    = var.labware_library_domain_name
  route53_zone_id = data.aws_route53_zone.labware_library.zone_id
  create_validation = false  # Disable validation for existing certificate
  tags = merge(local.common_tags, {
    Project = "opentrons-labware-library"
  })
  
  providers = {
    aws = aws.us_east_1
  }
  
  depends_on = [data.aws_route53_zone.labware_library]
}

# Hosted Zone for Protocol Designer (delegated subdomain)
# Data source to reference the main designer zone from production
data "aws_route53_zone" "protocol_designer" {
  name = "designer.opentrons.com"
  
  tags = {
    Environment = "production"
    Project     = "opentrons-protocol-designer"
  }
}

# ACM Certificate for Protocol Designer
module "protocol_designer_certificate" {
  source = "../../modules/acm-certificate"

  environment    = var.environment
  domain_name    = var.protocol_designer_domain_name
  route53_zone_id = data.aws_route53_zone.protocol_designer.zone_id
  tags = merge(local.common_tags, {
    Project = "opentrons-protocol-designer"
  })
  
  providers = {
    aws = aws.us_east_1
  }
  
  depends_on = [data.aws_route53_zone.protocol_designer]
}

# S3 Bucket using the docs-buckets module
module "docs_bucket" {
  source = "../../modules/docs-buckets"

  bucket_name                           = var.mkdocs_bucket_name
  resource_name                         = "docs"
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
  resource_name                         = "labware"
  environment                          = var.environment
  enable_public_access                 = false  # CloudFront only access
  enable_versioning                    = var.enable_versioning
  enable_lifecycle_rules               = var.enable_lifecycle_rules
  noncurrent_version_expiration_days   = var.noncurrent_version_expiration_days
  tags                                 = merge(local.common_tags, {
    Project = "opentrons-labware-library"
  })
}

# Protocol Designer S3 Bucket using the docs-buckets module
module "protocol_designer_bucket" {
  source = "../../modules/docs-buckets"

  bucket_name                           = var.protocol_designer_bucket_name
  resource_name                         = "designer"
  environment                          = var.environment
  enable_public_access                 = false  # CloudFront only access
  enable_versioning                    = var.enable_versioning
  enable_lifecycle_rules               = var.enable_lifecycle_rules
  noncurrent_version_expiration_days   = var.noncurrent_version_expiration_days
  tags                                 = merge(local.common_tags, {
    Project = "opentrons-protocol-designer"
  })
}

# CloudFront Distribution using the cloudfront-distribution module
module "docs_cloudfront_distribution" {
  source = "../../modules/cloudfront-distribution"

  environment              = var.environment
  project                  = "mkdocs"
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
  acm_certificate_arn      = module.mkdocs_certificate.certificate_arn
  ssl_support_method       = "sni-only"
  minimum_protocol_version = "TLSv1.2_2021"
  
  # WAF configuration (not configured for staging)
  web_acl_id = var.web_acl_id
  
  tags = merge(local.common_tags, {
    Name = "staging.docs.opentrons.com"
  })
  
  depends_on = [module.docs_bucket, module.mkdocs_certificate, data.aws_route53_zone.mkdocs]
}

# CloudFront Distribution for Labware Library using the cloudfront-distribution module
module "labware_library_cloudfront_distribution" {
  source = "../../modules/cloudfront-distribution"

  environment              = var.environment
  project                  = "labware"
  enabled                  = true
  is_ipv6_enabled          = true
  comment                  = "Staging labware library distribution"
  default_root_object      = "index.html"
  price_class              = "PriceClass_100"  # Use only North America and Europe
  # aliases                  = [var.labware_library_domain_name]  # Temporarily commented out to avoid CNAME conflict
  
  # Origin configuration
  origin_domain_name       = "${var.labware_library_bucket_name}.s3.${var.aws_region}.amazonaws.com"
  origin_id                = "${var.labware_library_bucket_name}-origin"
  custom_user_agent        = "Opentrons-Labware-Library-Staging"
  
  # S3 bucket configuration
  s3_bucket_id             = module.labware_library_bucket.bucket_name
  s3_bucket_arn            = module.labware_library_bucket.bucket_arn
  
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
  acm_certificate_arn      = module.labware_certificate.certificate_arn
  ssl_support_method       = "sni-only"
  minimum_protocol_version = "TLSv1.2_2021"
  
  # WAF configuration (not configured for staging)
  web_acl_id = var.web_acl_id
  
  # S3 bucket policy (disabled - using existing policy)
  create_s3_bucket_policy = false
  
  tags = merge(local.common_tags, {
    Name = "staging.labware.opentrons.com"
  })
  
  depends_on = [module.labware_library_bucket, module.labware_certificate, data.aws_route53_zone.labware_library]
}

# CloudFront Distribution for Protocol Designer using the cloudfront-distribution module
module "protocol_designer_cloudfront_distribution" {
  source = "../../modules/cloudfront-distribution"

  environment              = var.environment
  project                  = "designer"
  enabled                  = true
  is_ipv6_enabled          = true
  comment                  = "Staging protocol designer distribution"
  default_root_object      = "index.html"
  price_class              = "PriceClass_100"  # Use only North America and Europe
  aliases                  = [var.protocol_designer_domain_name]
  
  # Origin configuration
  origin_domain_name       = "${var.protocol_designer_bucket_name}.s3.${var.aws_region}.amazonaws.com"
  origin_id                = "${var.protocol_designer_bucket_name}-origin"
  custom_user_agent        = "Opentrons-Protocol-Designer-Staging"
  
  # S3 bucket configuration
  s3_bucket_id             = module.protocol_designer_bucket.bucket_name
  s3_bucket_arn            = module.protocol_designer_bucket.bucket_arn
  
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
  acm_certificate_arn      = module.protocol_designer_certificate.certificate_arn
  ssl_support_method       = "sni-only"
  minimum_protocol_version = "TLSv1.2_2021"
  
  # WAF configuration (not configured for staging)
  web_acl_id = var.web_acl_id
  
  # S3 bucket policy (disabled - using existing policy)
  create_s3_bucket_policy = false
  
  tags = merge(local.common_tags, {
    Name = "staging.designer.opentrons.com"
  })
  
  depends_on = [module.protocol_designer_bucket, module.protocol_designer_certificate, data.aws_route53_zone.protocol_designer]
}

# DNS Records for staging subdomains
resource "aws_route53_record" "staging_docs" {
  zone_id = data.aws_route53_zone.mkdocs.zone_id
  name    = "staging.docs.opentrons.com"
  type    = "A"

  alias {
    name                   = module.docs_cloudfront_distribution.distribution_domain_name
    zone_id                = module.docs_cloudfront_distribution.distribution_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "staging_labware" {
  zone_id = data.aws_route53_zone.labware_library.zone_id
  name    = "staging.labware.opentrons.com"
  type    = "A"

  alias {
    name                   = module.labware_library_cloudfront_distribution.distribution_domain_name
    zone_id                = module.labware_library_cloudfront_distribution.distribution_hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "staging_designer" {
  zone_id = data.aws_route53_zone.protocol_designer.zone_id
  name    = "staging.designer.opentrons.com"
  type    = "A"

  alias {
    name                   = module.protocol_designer_cloudfront_distribution.distribution_domain_name
    zone_id                = module.protocol_designer_cloudfront_distribution.distribution_hosted_zone_id
    evaluate_target_health = false
  }
}



