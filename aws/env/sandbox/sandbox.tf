# Sandbox Environment Configuration
# This file configures the sandbox environment for Opentrons documentation

provider "aws" {
  region  = "us-east-2"
  profile = "robotics-protocol-library-prod-root"
}

# Note: SSL certificate already exists and is managed outside of Terraform
# The existing CloudFront distribution already has the certificate configured

# Sandbox Documentation S3 Bucket
# Note: This bucket already exists and will be imported
resource "aws_s3_bucket" "docs" {
  bucket = "sandbox.docs"
  
  tags = {
    Environment = "sandbox"
    environment = "sandbox"
    ou          = "robotics"
  }
}

# Note: S3 bucket website configuration is not enabled on the existing bucket

# Note: WAF Web ACL is not currently configured for sandbox

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
    domain_name = "sandbox.docs.s3.us-east-2.amazonaws.com"
    origin_id   = "sandbox.docs.s3.us-east-2.amazonaws.com-me2w5chhutr"
    origin_access_control_id = "E2V32V68SQH1E3"
  }
  
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "sandbox.docs.s3.us-east-2.amazonaws.com-me2w5chhutr"
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    compress = true
    min_ttl = 0
    default_ttl = 0
    max_ttl = 0
    viewer_protocol_policy = "redirect-to-https"
    
    function_association {
      event_type   = "viewer-request"
      function_arn = "arn:aws:cloudfront::043748923082:function/indexRedirect"
    }
  }
  
  custom_error_response {
    error_code = 404
    response_code = 404
    response_page_path = "/edge/404.html"
    error_caching_min_ttl = 10
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn           = "arn:aws:acm:us-east-1:043748923082:certificate/fefdb546-2e50-46fc-8781-efd96521e779"
    ssl_support_method            = "sni-only"
    minimum_protocol_version      = "TLSv1.2_2021"
  }
  
  aliases = ["sandbox.docs.opentrons.com"]
  
  tags = {
    Name = "sandbox.docs"
  }
}

# Outputs for sandbox environment
output "sandbox_bucket_name" {
  description = "Sandbox documentation bucket name"
  value       = aws_s3_bucket.docs.bucket
}

output "sandbox_bucket_arn" {
  description = "Sandbox documentation bucket ARN"
  value       = aws_s3_bucket.docs.arn
}

output "sandbox_website_endpoint" {
  description = "Sandbox documentation website endpoint"
  value       = "Website configuration not enabled"
}

output "sandbox_cloudfront_domain" {
  description = "Sandbox CloudFront distribution domain"
  value       = aws_cloudfront_distribution.docs_cloudfront.domain_name
}

output "sandbox_cloudfront_id" {
  description = "Sandbox CloudFront distribution ID"
  value       = aws_cloudfront_distribution.docs_cloudfront.id
}

output "sandbox_deployment_url" {
  description = "Sandbox documentation deployment URL"
  value       = "https://sandbox.docs.opentrons.com/"
}

