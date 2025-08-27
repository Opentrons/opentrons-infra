# Staging Environment Configuration
# This file configures the staging environment for Opentrons documentation

provider "aws" {
  region  = "us-east-2"
  profile = "robotics-protocol-library-prod-root"
}

# Note: SSL certificate already exists and is managed outside of Terraform
# The existing CloudFront distribution already has the certificate configured

# Staging Documentation S3 Bucket
# Note: This bucket already exists and will be imported
resource "aws_s3_bucket" "docs" {
  bucket = "opentrons.staging.docs"
  
  tags = {
    Environment = "staging"
    environment = "staging"
    ou          = "robotics"
  }
}

# Note: S3 bucket website configuration is not enabled on the existing bucket

# Note: WAF Web ACL is not currently configured for staging

# Note: CloudFront functions are not currently configured

# CloudFront Distribution for Documentation
# Note: This distribution already exists and will be imported
resource "aws_cloudfront_distribution" "docs_cloudfront" {
  # Import existing configuration - minimal config to avoid changes
  enabled = true
  is_ipv6_enabled = true
  default_root_object = "index.html"
  
  # Required blocks - will be imported from existing distribution
  origin {
    domain_name = "opentrons.staging.docs.s3.us-east-2.amazonaws.com"
    origin_id   = "opentrons.staging.docs.s3.us-east-2.amazonaws.com-me0ka7dxf8p"
    origin_access_control_id = "E3BNFA9HMUN4D3"
  }
  
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "opentrons.staging.docs.s3.us-east-2.amazonaws.com-me0ka7dxf8p"
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    compress = true
    min_ttl = 0
    default_ttl = 0
    max_ttl = 0
    viewer_protocol_policy = "allow-all"
    
    function_association {
      event_type   = "viewer-request"
      function_arn = "arn:aws:cloudfront::043748923082:function/indexRedirect"
    }
  }
  
  custom_error_response {
    error_code = 404
    response_code = 404
    response_page_path = "/404.html"
    error_caching_min_ttl = 10
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn           = "arn:aws:acm:us-east-1:043748923082:certificate/5edbb417-cdbd-4fbc-8f19-18fbc169c531"
    ssl_support_method            = "sni-only"
    minimum_protocol_version      = "TLSv1.2_2021"
  }
  
  aliases = ["staging.docs.opentrons.com"]
  
  tags = {
    Name = "staging.docs.opentrons.com"
  }
}

# Outputs for staging environment
output "staging_bucket_name" {
  description = "Staging documentation bucket name"
  value       = aws_s3_bucket.docs.bucket
}

output "staging_bucket_arn" {
  description = "Staging documentation bucket ARN"
  value       = aws_s3_bucket.docs.arn
}

output "staging_website_endpoint" {
  description = "Staging documentation website endpoint"
  value       = "Website configuration not enabled"
}

output "staging_cloudfront_domain" {
  description = "Staging CloudFront distribution domain"
  value       = aws_cloudfront_distribution.docs_cloudfront.domain_name
}

output "staging_cloudfront_id" {
  description = "Staging CloudFront distribution ID"
  value       = aws_cloudfront_distribution.docs_cloudfront.id
}

output "staging_deployment_url" {
  description = "Staging documentation deployment URL"
  value       = "https://staging.docs.opentrons.com/"
}

