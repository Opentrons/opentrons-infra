# CloudFront Distribution Module
# This module creates a CloudFront distribution for S3 bucket hosting

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = var.origin_access_control_name != null ? var.origin_access_control_name : (var.project != null ? "${var.environment}-${var.project}-oac" : "${var.environment}-oac")
  description                       = "OAC for ${var.environment} ${var.project != null ? var.project : ""} CloudFront distribution"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "distribution" {
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = var.comment
  default_root_object = var.default_root_object
  price_class         = var.price_class
  aliases             = var.aliases
  web_acl_id          = var.web_acl_id

  # Origin configuration
  origin {
    domain_name = var.origin_domain_name
    origin_id   = var.origin_id

    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id

    custom_header {
      name  = "User-Agent"
      value = var.custom_user_agent
    }
  }

  # Default cache behavior
  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = var.forward_query_string
      cookies {
        forward = var.forward_cookies
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
    compress               = var.compress

    # Function associations
    dynamic "function_association" {
      for_each = var.function_associations
      content {
        event_type   = function_association.value.event_type
        function_arn = function_association.value.function_arn
      }
    }
  }

  # Custom error responses
  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_code            = custom_error_response.value.error_code
      response_code         = lookup(custom_error_response.value, "response_code", null)
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
      error_caching_min_ttl = lookup(custom_error_response.value, "error_caching_min_ttl", null)
    }
  }

  # Restrictions
  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  # Viewer certificate
  viewer_certificate {
    cloudfront_default_certificate = var.use_default_certificate
    acm_certificate_arn           = var.acm_certificate_arn
    ssl_support_method            = var.ssl_support_method
    minimum_protocol_version      = var.minimum_protocol_version
  }

  tags = merge({
    Name        = "${var.environment}-cloudfront"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

# S3 bucket policy to allow CloudFront access only
resource "aws_s3_bucket_policy" "cloudfront_access" {
  bucket = var.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "CloudFrontAccess"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${var.s3_bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.distribution.arn
          }
        }
      },
    ]
  })
}
