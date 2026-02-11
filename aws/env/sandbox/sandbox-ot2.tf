# Separate infrastructure for ot2 subdomains (Protocol Designer and Labware Library).
# ot2.sandbox.designer.opentrons.com and ot2.sandbox.labware.opentrons.com - independent S3 + CloudFront per app.

locals {
  ot2_protocol_designer_domain = "ot2.${var.protocol_designer_domain_name}"
  ot2_labware_library_domain   = "ot2.${var.labware_library_domain_name}"
}

# --- ot2 Protocol Designer ---

module "ot2_protocol_designer_certificate" {
  source = "../../modules/acm-certificate"

  environment       = var.environment
  domain_name       = local.ot2_protocol_designer_domain
  route53_zone_id   = data.aws_route53_zone.protocol_designer.zone_id
  create_validation = true
  tags = merge(local.common_tags, {
    Project = "opentrons-protocol-designer"
    Name    = "ot2-protocol-designer-sandbox"
  })

  providers = {
    aws = aws.us_east_1
  }

  depends_on = [data.aws_route53_zone.protocol_designer]
}

module "ot2_protocol_designer_bucket" {
  source = "../../modules/docs-buckets"

  bucket_name                         = var.ot2_protocol_designer_bucket_name
  resource_name                       = "designer-ot2"
  environment                        = var.environment
  enable_public_access                = false
  enable_versioning                   = var.enable_versioning
  enable_lifecycle_rules              = var.enable_lifecycle_rules
  noncurrent_version_expiration_days  = var.noncurrent_version_expiration_days
  tags = merge(local.common_tags, {
    Project = "opentrons-protocol-designer"
  })
}

module "ot2_protocol_designer_cloudfront_distribution" {
  source = "../../modules/cloudfront-distribution"

  environment             = var.environment
  project                 = "designer-ot2"
  enabled                 = true
  is_ipv6_enabled         = true
  comment                 = "Sandbox ot2 protocol designer (separate infra)"
  default_root_object     = "index.html"
  price_class             = "PriceClass_100"
  aliases                 = [local.ot2_protocol_designer_domain]

  origin_domain_name      = "${var.ot2_protocol_designer_bucket_name}.s3.${var.aws_region}.amazonaws.com"
  origin_id               = "${var.ot2_protocol_designer_bucket_name}-origin"
  custom_user_agent       = "Opentrons-Protocol-Designer-Sandbox-OT2"

  s3_bucket_id            = module.ot2_protocol_designer_bucket.bucket_name
  s3_bucket_arn           = module.ot2_protocol_designer_bucket.bucket_arn

  allowed_methods         = ["GET", "HEAD"]
  cached_methods          = ["GET", "HEAD"]
  forward_query_string    = true
  forward_cookies         = "all"
  viewer_protocol_policy  = "redirect-to-https"
  min_ttl                 = 0
  default_ttl             = 0
  max_ttl                 = 0
  compress                = true

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

  geo_restriction_type      = "none"
  geo_restriction_locations = []

  use_default_certificate   = false
  acm_certificate_arn       = module.ot2_protocol_designer_certificate.certificate_arn
  ssl_support_method        = "sni-only"
  minimum_protocol_version  = "TLSv1.2_2021"
  web_acl_id                = var.web_acl_id

  tags = merge(local.common_tags, {
    Name = "ot2.sandbox.designer.opentrons.com"
  })

  depends_on = [module.ot2_protocol_designer_bucket, module.ot2_protocol_designer_certificate, data.aws_route53_zone.protocol_designer]
}

resource "aws_route53_record" "ot2_sandbox_designer" {
  zone_id = data.aws_route53_zone.protocol_designer.zone_id
  name    = local.ot2_protocol_designer_domain
  type    = "A"

  alias {
    name                   = module.ot2_protocol_designer_cloudfront_distribution.distribution_domain_name
    zone_id                = module.ot2_protocol_designer_cloudfront_distribution.distribution_hosted_zone_id
    evaluate_target_health = false
  }
}

# --- ot2 Labware Library ---

module "ot2_labware_library_certificate" {
  source = "../../modules/acm-certificate"

  environment       = var.environment
  domain_name       = local.ot2_labware_library_domain
  route53_zone_id   = data.aws_route53_zone.labware_library.zone_id
  create_validation = true
  tags = merge(local.common_tags, {
    Project = "opentrons-labware-library"
    Name    = "ot2-labware-library-sandbox"
  })

  providers = {
    aws = aws.us_east_1
  }

  depends_on = [data.aws_route53_zone.labware_library]
}

module "ot2_labware_library_bucket" {
  source = "../../modules/docs-buckets"

  bucket_name                         = var.ot2_labware_library_bucket_name
  resource_name                       = "labware-ot2"
  environment                        = var.environment
  enable_public_access                = false
  enable_versioning                   = var.enable_versioning
  enable_lifecycle_rules              = var.enable_lifecycle_rules
  noncurrent_version_expiration_days  = var.noncurrent_version_expiration_days
  tags = merge(local.common_tags, {
    Project = "opentrons-labware-library"
  })
}

module "ot2_labware_library_cloudfront_distribution" {
  source = "../../modules/cloudfront-distribution"

  environment             = var.environment
  project                 = "labware-ot2"
  enabled                 = true
  is_ipv6_enabled         = true
  comment                 = "Sandbox ot2 labware library (separate infra)"
  default_root_object     = "index.html"
  price_class             = "PriceClass_100"
  aliases                 = [local.ot2_labware_library_domain]

  origin_domain_name      = "${var.ot2_labware_library_bucket_name}.s3.${var.aws_region}.amazonaws.com"
  origin_id               = "${var.ot2_labware_library_bucket_name}-origin"
  custom_user_agent       = "Opentrons-Labware-Library-Sandbox-OT2"

  s3_bucket_id            = module.ot2_labware_library_bucket.bucket_name
  s3_bucket_arn           = module.ot2_labware_library_bucket.bucket_arn

  allowed_methods         = ["GET", "HEAD"]
  cached_methods          = ["GET", "HEAD"]
  forward_query_string    = true
  forward_cookies         = "all"
  viewer_protocol_policy  = "redirect-to-https"
  min_ttl                 = 0
  default_ttl             = 0
  max_ttl                 = 0
  compress                = true

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

  geo_restriction_type      = "none"
  geo_restriction_locations = []

  use_default_certificate   = false
  acm_certificate_arn       = module.ot2_labware_library_certificate.certificate_arn
  ssl_support_method        = "sni-only"
  minimum_protocol_version  = "TLSv1.2_2021"
  web_acl_id                = var.web_acl_id

  tags = merge(local.common_tags, {
    Name = "ot2.sandbox.labware.opentrons.com"
  })

  depends_on = [module.ot2_labware_library_bucket, module.ot2_labware_library_certificate, data.aws_route53_zone.labware_library]
}

resource "aws_route53_record" "ot2_sandbox_labware" {
  zone_id = data.aws_route53_zone.labware_library.zone_id
  name    = local.ot2_labware_library_domain
  type    = "A"

  alias {
    name                   = module.ot2_labware_library_cloudfront_distribution.distribution_domain_name
    zone_id                = module.ot2_labware_library_cloudfront_distribution.distribution_hosted_zone_id
    evaluate_target_health = false
  }
}
