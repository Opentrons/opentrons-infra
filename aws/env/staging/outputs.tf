# Outputs for staging environment

output "staging_bucket_name" {
  description = "Staging documentation bucket name"
  value       = module.docs_bucket.bucket_name
}

output "staging_bucket_arn" {
  description = "Staging documentation bucket ARN"
  value       = module.docs_bucket.bucket_arn
}

output "staging_bucket_id" {
  description = "Staging documentation bucket ID"
  value       = module.docs_bucket.bucket_name
}

output "staging_labware_library_bucket_name" {
  description = "Staging labware library bucket name"
  value       = module.labware_library_bucket.bucket_name
}

output "staging_labware_library_bucket_arn" {
  description = "Staging labware library bucket ARN"
  value       = module.labware_library_bucket.bucket_arn
}

output "staging_cloudfront_domain" {
  description = "Staging CloudFront distribution domain"
  value       = module.docs_cloudfront_distribution.distribution_domain_name
}

output "staging_cloudfront_id" {
  description = "Staging CloudFront distribution ID"
  value       = module.docs_cloudfront_distribution.distribution_id
}

output "staging_cloudfront_arn" {
  description = "Staging CloudFront distribution ARN"
  value       = module.docs_cloudfront_distribution.distribution_arn
}

output "staging_deployment_url" {
  description = "Staging documentation deployment URL"
  value       = "https://${var.domain_name}/"
}

output "staging_origin_access_control_id" {
  description = "Staging CloudFront origin access control ID"
  value       = module.docs_cloudfront_distribution.origin_access_control_id
}

output "staging_labware_library_cloudfront_domain" {
  description = "Staging labware library CloudFront distribution domain"
  value       = module.labware_library_cloudfront_distribution.distribution_domain_name
}

output "staging_labware_library_cloudfront_id" {
  description = "Staging labware library CloudFront distribution ID"
  value       = module.labware_library_cloudfront_distribution.distribution_id
}

output "staging_labware_library_cloudfront_arn" {
  description = "Staging labware library CloudFront distribution ARN"
  value       = module.labware_library_cloudfront_distribution.distribution_arn
}

output "staging_labware_library_deployment_url" {
  description = "Staging labware library deployment URL"
  value       = "https://${var.labware_library_domain_name}/"
}

output "staging_labware_library_origin_access_control_id" {
  description = "Staging labware library CloudFront origin access control ID"
  value       = module.labware_library_cloudfront_distribution.origin_access_control_id
}

output "staging_protocol_designer_bucket_name" {
  description = "Staging protocol designer bucket name"
  value       = module.protocol_designer_bucket.bucket_name
}

output "staging_protocol_designer_bucket_arn" {
  description = "Staging protocol designer bucket ARN"
  value       = module.protocol_designer_bucket.bucket_arn
}

output "staging_protocol_designer_cloudfront_domain" {
  description = "Staging protocol designer CloudFront distribution domain"
  value       = module.protocol_designer_cloudfront_distribution.distribution_domain_name
}

output "staging_protocol_designer_cloudfront_id" {
  description = "Staging protocol designer CloudFront distribution ID"
  value       = module.protocol_designer_cloudfront_distribution.distribution_id
}

output "staging_protocol_designer_cloudfront_arn" {
  description = "Staging protocol designer CloudFront distribution ARN"
  value       = module.protocol_designer_cloudfront_distribution.distribution_arn
}

output "staging_protocol_designer_deployment_url" {
  description = "Staging protocol designer deployment URL"
  value       = "https://${var.protocol_designer_domain_name}/"
}

output "staging_protocol_designer_certificate_arn" {
  description = "Staging protocol designer ACM certificate ARN"
  value       = module.protocol_designer_certificate.certificate_arn
}

output "staging_protocol_designer_zone_id" {
  description = "Staging protocol designer hosted zone ID"
  value       = aws_route53_zone.protocol_designer.zone_id
}

output "staging_protocol_designer_nameservers" {
  description = "Staging protocol designer nameservers for delegation"
  value       = aws_route53_zone.protocol_designer.name_servers
}
