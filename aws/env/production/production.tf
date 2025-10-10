# Production Environment Configuration

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

# Hosted Zone for MkDocs (delegated subdomain)
resource "aws_route53_zone" "mkdocs" {
  name = var.domain_name
  
  tags = merge(local.common_tags, {
    Name = "mkdocs-zone"
    Project = "opentrons-docs"
  })
}

# ACM Certificate for MkDocs
module "mkdocs_certificate" {
  source = "../../modules/acm-certificate"

  environment    = var.environment
  domain_name    = var.domain_name
  route53_zone_id = aws_route53_zone.mkdocs.zone_id
  create_validation = false  # Disable validation for existing certificate
  tags = merge(local.common_tags, {
    Project = "opentrons-docs"
  })
  
  providers = {
    aws = aws.us_east_1
  }
  
  depends_on = [aws_route53_zone.mkdocs]
}

# Hosted Zone for Labware Library (delegated subdomain)
resource "aws_route53_zone" "labware_library" {
  name = var.labware_library_domain_name
  
  tags = merge(local.common_tags, {
    Name = "labware-library-zone"
    Project = "opentrons-labware-library"
  })
}

# ACM Certificate for Labware Library
module "labware_certificate" {
  source = "../../modules/acm-certificate"

  environment    = var.environment
  domain_name    = var.labware_library_domain_name
  route53_zone_id = aws_route53_zone.labware_library.zone_id
  create_validation = false  # Disable validation for existing certificate
  tags = merge(local.common_tags, {
    Project = "opentrons-labware-library"
  })
  
  providers = {
    aws = aws.us_east_1
  }
  
  depends_on = [aws_route53_zone.labware_library]
}

# Hosted Zone for Protocol Designer (delegated subdomain)
resource "aws_route53_zone" "protocol_designer" {
  name = var.protocol_designer_domain_name
  
  tags = merge(local.common_tags, {
    Name = "protocol-designer-zone"
    Project = "opentrons-protocol-designer"
  })
}

# ACM Certificate for Protocol Designer
module "protocol_designer_certificate" {
  source = "../../modules/acm-certificate"

  environment    = var.environment
  domain_name    = var.protocol_designer_domain_name
  subject_alternative_names = ["*.designer.opentrons.com", "www.designer.opentrons.com"]
  route53_zone_id = aws_route53_zone.protocol_designer.zone_id
  create_validation = false  # Disable validation for existing certificate
  tags = {
    Environment = "prod"
    Name = "designer.opentrons.com"
    ou = "robotics"
  }
  
  providers = {
    aws = aws.us_east_1
  }
  
  depends_on = [aws_route53_zone.protocol_designer]
}


# S3 Bucket for MkDocs documentation using the docs-buckets module
  module "docs_bucket" {
  source = "../../modules/docs-buckets"

  bucket_name                           = var.mkdocs_bucket_name
  resource_name                         = "docs"
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

# S3 Bucket for Protocol Designer using the docs-buckets module
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

# CloudFront Distribution for MkDocs using the cloudfront-distribution module
module "docs_cloudfront_distribution" {
  source = "../../modules/cloudfront-distribution"

  environment              = var.environment
  project                  = "mkdocs"
  enabled                  = true
  is_ipv6_enabled          = true
  comment                  = "Production documentation distribution"
  default_root_object      = "index.html"
  price_class              = "PriceClass_100"  # Use only North America and Europe
  aliases                  = [var.domain_name]
  
  origin_domain_name       = "${var.mkdocs_bucket_name}.s3.${var.aws_region}.amazonaws.com"
  origin_id                = "${var.mkdocs_bucket_name}-origin"
  custom_user_agent        = "Opentrons-Docs-Production"
  
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
  
  # SSL/TLS configuration
  use_default_certificate  = false
  acm_certificate_arn      = module.mkdocs_certificate.certificate_arn
  ssl_support_method       = "sni-only"
  minimum_protocol_version = "TLSv1.2_2021"
  
  # WAF configuration
  web_acl_id = var.web_acl_id
  
  tags = merge(local.common_tags, {
    Name = "docs.opentrons.com"
  })
  
  depends_on = [module.mkdocs_certificate, module.docs_bucket, aws_route53_zone.mkdocs]
}

# CloudFront Distribution for Labware Library using the cloudfront-distribution module
module "labware_library_cloudfront_distribution" {
  source = "../../modules/cloudfront-distribution"

  environment              = var.environment
  project                  = "labware"
  enabled                  = true
  is_ipv6_enabled          = true
  comment                  = "Production labware library distribution"
  default_root_object      = "index.html"
  price_class              = "PriceClass_100"  # Use only North America and Europe
  # aliases                  = [var.labware_library_domain_name]  # Temporarily commented out to avoid CNAME conflict
  
  origin_domain_name       = "${var.labware_library_bucket_name}.s3.${var.aws_region}.amazonaws.com"
  origin_id                = "${var.labware_library_bucket_name}-origin"
  custom_user_agent        = "Opentrons-Labware-Library-Production"
  
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
  
  # SSL/TLS configuration
  use_default_certificate  = false
  acm_certificate_arn      = module.labware_certificate.certificate_arn
  ssl_support_method       = "sni-only"
  minimum_protocol_version = "TLSv1.2_2021"
  
  # WAF configuration
  web_acl_id = var.web_acl_id
  
  tags = merge(local.common_tags, {
    Name = "labware.library.opentrons.com"
  })
  
  depends_on = [module.labware_certificate, module.labware_library_bucket, aws_route53_zone.labware_library]
}

# CloudFront Distribution for Protocol Designer using the cloudfront-distribution module
module "protocol_designer_cloudfront_distribution" {
  source = "../../modules/cloudfront-distribution"

  environment              = var.environment
  project                  = "designer"
  enabled                  = true
  is_ipv6_enabled          = true
  comment                  = "Production protocol designer distribution"
  default_root_object      = "index.html"
  price_class              = "PriceClass_100"  # Use only North America and Europe
  # No aliases - use default CloudFront domain
  
  origin_domain_name       = "${var.protocol_designer_bucket_name}.s3.${var.aws_region}.amazonaws.com"
  origin_id                = "${var.protocol_designer_bucket_name}-origin"
  custom_user_agent        = "Opentrons-Protocol-Designer-Production"
  
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
  
  # SSL/TLS configuration
  use_default_certificate  = false
  acm_certificate_arn      = module.protocol_designer_certificate.certificate_arn
  ssl_support_method       = "sni-only"
  minimum_protocol_version = "TLSv1.2_2021"
  
  # WAF configuration
  web_acl_id = var.web_acl_id
  
  tags = merge(local.common_tags, {
    Name = "designer.opentrons.com"
  })
  
  depends_on = [module.protocol_designer_certificate, module.protocol_designer_bucket, aws_route53_zone.protocol_designer]
}

