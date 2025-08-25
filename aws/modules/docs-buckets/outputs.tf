# Outputs for Documentation S3 Buckets Module

output "sandbox_bucket_name" {
  description = "Name of the sandbox documentation bucket"
  value       = aws_s3_bucket.sandbox_docs.bucket
}

output "sandbox_bucket_arn" {
  description = "ARN of the sandbox documentation bucket"
  value       = aws_s3_bucket.sandbox_docs.arn
}

output "sandbox_website_endpoint" {
  description = "Website endpoint for the sandbox documentation bucket"
  value       = aws_s3_bucket_website_configuration.sandbox_docs.website_endpoint
}

output "staging_bucket_name" {
  description = "Name of the staging documentation bucket"
  value       = aws_s3_bucket.staging_docs.bucket
}

output "staging_bucket_arn" {
  description = "ARN of the staging documentation bucket"
  value       = aws_s3_bucket.staging_docs.arn
}

output "staging_website_endpoint" {
  description = "Website endpoint for the staging documentation bucket"
  value       = aws_s3_bucket_website_configuration.staging_docs.website_endpoint
}

output "production_bucket_name" {
  description = "Name of the production documentation bucket"
  value       = aws_s3_bucket.production_docs.bucket
}

output "production_bucket_arn" {
  description = "ARN of the production documentation bucket"
  value       = aws_s3_bucket.production_docs.arn
}

output "production_website_endpoint" {
  description = "Website endpoint for the production documentation bucket"
  value       = aws_s3_bucket_website_configuration.production_docs.website_endpoint
}

output "all_bucket_names" {
  description = "Names of all documentation buckets"
  value = {
    sandbox    = aws_s3_bucket.sandbox_docs.bucket
    staging    = aws_s3_bucket.staging_docs.bucket
    production = aws_s3_bucket.production_docs.bucket
  }
}

output "all_bucket_arns" {
  description = "ARNs of all documentation buckets"
  value = {
    sandbox    = aws_s3_bucket.sandbox_docs.arn
    staging    = aws_s3_bucket.staging_docs.arn
    production = aws_s3_bucket.production_docs.arn
  }
}

output "all_website_endpoints" {
  description = "Website endpoints for all documentation buckets"
  value = {
    sandbox    = aws_s3_bucket_website_configuration.sandbox_docs.website_endpoint
    staging    = aws_s3_bucket_website_configuration.staging_docs.website_endpoint
    production = aws_s3_bucket_website_configuration.production_docs.website_endpoint
  }
}


