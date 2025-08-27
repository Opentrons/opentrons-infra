# Outputs for Documentation S3 Buckets Module

output "bucket_name" {
  description = "Name of the documentation bucket"
  value       = aws_s3_bucket.docs.bucket
}

output "bucket_arn" {
  description = "ARN of the documentation bucket"
  value       = aws_s3_bucket.docs.arn
}

output "website_endpoint" {
  description = "Website endpoint for the documentation bucket"
  value       = aws_s3_bucket_website_configuration.docs.website_endpoint
}

output "website_domain" {
  description = "Website domain for the documentation bucket"
  value       = aws_s3_bucket_website_configuration.docs.website_domain
}


