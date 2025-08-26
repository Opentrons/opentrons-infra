# Production Environment Configuration
# This file configures the production environment for Opentrons documentation

provider "aws" {
  region  = "us-east-2"
  profile = "robotics-protocol-library-prod-root"
}

# Note: SSL certificate already exists and is managed outside of Terraform
# The existing CloudFront distribution already has the certificate configured

# Production Documentation S3 Bucket
# Note: This bucket already exists and will be imported
resource "aws_s3_bucket" "docs" {
  bucket = "opentrons.production.docs"
  
  tags = {
    Environment = "production"
    environment = "production"
    ou          = "robotics"
  }
}

# Note: S3 bucket website configuration is not enabled on the existing bucket

# Note: WAF Web ACL already exists and is managed by CloudFront
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
    domain_name = "opentrons.production.docs.s3.us-east-2.amazonaws.com"
    origin_id   = "opentrons.production.docs.s3.us-east-2.amazonaws.com-mekji3ceiqy"
    origin_access_control_id = "E3VB3LKZ4DM8A1"
  }
  
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "opentrons.production.docs.s3.us-east-2.amazonaws.com-mekji3ceiqy"
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
    acm_certificate_arn           = "arn:aws:acm:us-east-1:043748923082:certificate/ddb7db56-f29e-4f1f-87a3-09f9cf0fb70c"
    ssl_support_method            = "sni-only"
    minimum_protocol_version      = "TLSv1.2_2021"
  }
  
  aliases = ["docs.opentrons.com"]
  web_acl_id = "arn:aws:wafv2:us-east-1:043748923082:global/webacl/CreatedByCloudFront-d198945c/a5351067-a055-4830-8622-8a6d645910a3"
  
  tags = {
    Name = "docs.opentrons.com"
  }
}

# Outputs for production environment
output "production_bucket_name" {
  description = "Production documentation bucket name"
  value       = aws_s3_bucket.docs.bucket
}

output "production_bucket_arn" {
  description = "Production documentation bucket ARN"
  value       = aws_s3_bucket.docs.arn
}

output "production_website_endpoint" {
  description = "Production documentation website endpoint"
  value       = "Website configuration not enabled"
}

output "production_cloudfront_domain" {
  description = "Production CloudFront distribution domain"
  value       = aws_cloudfront_distribution.docs_cloudfront.domain_name
}

output "production_cloudfront_id" {
  description = "Production CloudFront distribution ID"
  value       = aws_cloudfront_distribution.docs_cloudfront.id
}

output "production_deployment_url" {
  description = "Production documentation deployment URL"
  value       = "https://docs.opentrons.com/"
}

