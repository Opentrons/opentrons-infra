# Outputs for sandbox environment

output "sandbox_bucket_name" {
  description = "Sandbox documentation bucket name"
  value       = module.docs_bucket.bucket_name
}

output "sandbox_bucket_arn" {
  description = "Sandbox documentation bucket ARN"
  value       = module.docs_bucket.bucket_arn
}

output "sandbox_bucket_id" {
  description = "Sandbox documentation bucket ID"
  value       = module.docs_bucket.bucket_name
}

output "sandbox_labware_bucket_name" {
  description = "Sandbox labware library bucket name"
  value       = module.labware_library_bucket.bucket_name
}

output "sandbox_labware_bucket_arn" {
  description = "Sandbox labware library bucket ARN"
  value       = module.labware_library_bucket.bucket_arn
}

output "sandbox_docs_bucket_url" {
  description = "Sandbox documentation bucket URL"
  value       = "https://${module.docs_bucket.bucket_name}.s3.${var.aws_region}.amazonaws.com"
}

output "sandbox_labware_bucket_url" {
  description = "Sandbox labware library bucket URL"
  value       = "https://${module.labware_library_bucket.bucket_name}.s3.${var.aws_region}.amazonaws.com"
}

output "sandbox_cloudfront_domain" {
  description = "Sandbox CloudFront distribution domain"
  value       = module.docs_cloudfront_distribution.distribution_domain_name
}

output "sandbox_cloudfront_id" {
  description = "Sandbox CloudFront distribution ID"
  value       = module.docs_cloudfront_distribution.distribution_id
}

output "sandbox_cloudfront_arn" {
  description = "Sandbox CloudFront distribution ARN"
  value       = module.docs_cloudfront_distribution.distribution_arn
}

output "sandbox_labware_cloudfront_domain" {
  description = "Sandbox labware CloudFront distribution domain"
  value       = module.labware_library_cloudfront_distribution.distribution_domain_name
}

output "sandbox_labware_cloudfront_id" {
  description = "Sandbox labware CloudFront distribution ID"
  value       = module.labware_library_cloudfront_distribution.distribution_id
}

output "sandbox_cloudfront_url" {
  description = "Sandbox documentation CloudFront URL"
  value       = "https://${module.docs_cloudfront_distribution.distribution_domain_name}"
}

output "sandbox_labware_cloudfront_url" {
  description = "Sandbox labware library CloudFront URL"
  value       = "https://${module.labware_library_cloudfront_distribution.distribution_domain_name}"
}

output "sandbox_protocol_designer_bucket_name" {
  description = "Sandbox protocol designer bucket name"
  value       = module.protocol_designer_bucket.bucket_name
}

output "sandbox_protocol_designer_bucket_arn" {
  description = "Sandbox protocol designer bucket ARN"
  value       = module.protocol_designer_bucket.bucket_arn
}

output "sandbox_protocol_designer_bucket_url" {
  description = "Sandbox protocol designer bucket URL"
  value       = "https://${module.protocol_designer_bucket.bucket_name}.s3.${var.aws_region}.amazonaws.com"
}

output "sandbox_components_bucket_name" {
  description = "Sandbox components bucket name"
  value       = module.components_bucket.bucket_name
}

output "sandbox_components_bucket_arn" {
  description = "Sandbox components bucket ARN"
  value       = module.components_bucket.bucket_arn
}

output "sandbox_components_bucket_url" {
  description = "Sandbox components bucket URL"
  value       = "https://${module.components_bucket.bucket_name}.s3.${var.aws_region}.amazonaws.com"
}

output "sandbox_components_cloudfront_domain" {
  description = "Sandbox components CloudFront distribution domain"
  value       = module.components_cloudfront_distribution.distribution_domain_name
}

output "sandbox_components_cloudfront_id" {
  description = "Sandbox components CloudFront distribution ID"
  value       = module.components_cloudfront_distribution.distribution_id
}

output "sandbox_components_cloudfront_url" {
  description = "Sandbox components CloudFront URL"
  value       = "https://${module.components_cloudfront_distribution.distribution_domain_name}"
}
