# Production Environment Configuration
# This file configures the production environment for Opentrons documentation

# Production Documentation S3 Buckets
module "docs_buckets" {
  source = "../../modules/docs-buckets"
  
  bucket_name = "opentrons.production.docs"
  environment = "production"
  aws_region  = "us-east-2"
  
  enable_versioning = true
  enable_lifecycle_rules = true
  noncurrent_version_expiration_days = 30  # Longer retention for production
  
  tags = {
    Project     = "opentrons-docs"
    Environment = "production"
    Team        = "platform"
    CostCenter  = "engineering"
    ManagedBy   = "terraform"
  }
  
  providers = {
    aws = aws.robotics-protocol-library-prod
  }
}

# CloudFront Function for Security Headers
module "security_headers_function" {
  source = "../../modules/cloudfront-function"
  
  environment   = "production"
  function_name = "security-headers"
  function_code = <<-EOF
    function handler(event) {
      var response = event.response;
      var headers = response.headers;
      
      // Add security headers
      headers['x-content-type-options'] = {value: 'nosniff'};
      headers['x-frame-options'] = {value: 'DENY'};
      headers['x-xss-protection'] = {value: '1; mode=block'};
      headers['referrer-policy'] = {value: 'strict-origin-when-cross-origin'};
      headers['strict-transport-security'] = {value: 'max-age=31536000; includeSubDomains'};
      
      return response;
    }
  EOF
  
  providers = {
    aws = aws.robotics-protocol-library-prod
  }
}

# CloudFront Distribution for Documentation
module "docs_cloudfront" {
  source = "../../modules/cloudfront-distribution"
  
  environment        = "production"
  origin_domain_name = module.docs_buckets.website_endpoint
  origin_id          = "s3-docs-bucket"
  s3_bucket_id       = module.docs_buckets.bucket_name
  s3_bucket_arn      = module.docs_buckets.bucket_arn
  
  # Optional: Custom domain (uncomment when you have a certificate)
  # aliases = ["docs.opentrons.com"]
  
  # Function associations
  function_associations = [
    {
      event_type   = "viewer-response"
      function_arn = module.security_headers_function.function_arn
    }
  ]
  
  # Custom error responses
  custom_error_responses = [
    {
      error_code         = 404
      response_code      = 200
      response_page_path = "/index.html"
    }
  ]
  
  tags = {
    Project     = "opentrons-docs"
    Environment = "production"
    Team        = "platform"
    CostCenter  = "engineering"
    ManagedBy   = "terraform"
  }
  
  providers = {
    aws = aws.robotics-protocol-library-prod
  }
}

# Outputs for production environment
output "production_bucket_name" {
  description = "Production documentation bucket name"
  value       = module.docs_buckets.bucket_name
}

output "production_bucket_arn" {
  description = "Production documentation bucket ARN"
  value       = module.docs_buckets.bucket_arn
}

output "production_website_endpoint" {
  description = "Production documentation website endpoint"
  value       = module.docs_buckets.website_endpoint
}

output "production_cloudfront_domain" {
  description = "Production CloudFront distribution domain"
  value       = module.docs_cloudfront.distribution_domain_name
}

output "production_cloudfront_id" {
  description = "Production CloudFront distribution ID"
  value       = module.docs_cloudfront.distribution_id
}

output "production_deployment_url" {
  description = "Production documentation deployment URL"
  value       = "https://docs.opentrons.com/"
}

