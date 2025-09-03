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

output "sandbox_cloudfront_domain" {
  description = "Sandbox CloudFront distribution domain"
  value       = module.cloudfront_distribution.distribution_domain_name
}

output "sandbox_cloudfront_id" {
  description = "Sandbox CloudFront distribution ID"
  value       = module.cloudfront_distribution.distribution_id
}

output "sandbox_cloudfront_arn" {
  description = "Sandbox CloudFront distribution ARN"
  value       = module.cloudfront_distribution.distribution_arn
}

output "sandbox_deployment_url" {
  description = "Sandbox documentation deployment URL"
  value       = "https://${var.domain_name}/"
}

output "sandbox_origin_access_control_id" {
  description = "Sandbox CloudFront origin access control ID"
  value       = module.cloudfront_distribution.origin_access_control_id
}
