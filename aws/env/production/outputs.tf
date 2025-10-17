# Outputs for production environment

output "production_bucket_name" {
  description = "Production documentation bucket name"
  value       = module.docs_bucket.bucket_name
}

output "production_bucket_arn" {
  description = "Production documentation bucket ARN"
  value       = module.docs_bucket.bucket_arn
}

output "production_bucket_id" {
  description = "Production documentation bucket ID"
  value       = module.docs_bucket.bucket_name
}

output "production_labware_library_bucket_name" {
  description = "Production labware library bucket name"
  value       = module.labware_library_bucket.bucket_name
}

output "production_labware_library_bucket_arn" {
  description = "Production labware library bucket ARN"
  value       = module.labware_library_bucket.bucket_arn
}

output "production_cloudfront_domain" {
  description = "Production CloudFront distribution domain"
  value       = module.docs_cloudfront_distribution.distribution_domain_name
}

output "production_cloudfront_id" {
  description = "Production CloudFront distribution ID"
  value       = module.docs_cloudfront_distribution.distribution_id
}

output "production_cloudfront_arn" {
  description = "Production CloudFront distribution ARN"
  value       = module.docs_cloudfront_distribution.distribution_arn
}

output "production_deployment_url" {
  description = "Production documentation deployment URL"
  value       = "https://${var.domain_name}/"
}

output "production_origin_access_control_id" {
  description = "Production CloudFront origin access control ID"
  value       = module.docs_cloudfront_distribution.origin_access_control_id
}

output "production_mkdocs_certificate_arn" {
  description = "Production MkDocs ACM certificate ARN"
  value       = module.mkdocs_certificate.certificate_arn
}

output "production_mkdocs_zone_id" {
  description = "Production MkDocs hosted zone ID"
  value       = aws_route53_zone.mkdocs.zone_id
}

output "production_mkdocs_nameservers" {
  description = "Production MkDocs nameservers for delegation"
  value       = aws_route53_zone.mkdocs.name_servers
}

output "production_labware_certificate_arn" {
  description = "Production labware library ACM certificate ARN"
  value       = module.labware_certificate.certificate_arn
}

output "production_labware_library_zone_id" {
  description = "Production labware library hosted zone ID"
  value       = aws_route53_zone.labware_library.zone_id
}

output "production_labware_library_nameservers" {
  description = "Production labware library nameservers for delegation"
  value       = aws_route53_zone.labware_library.name_servers
}

output "production_labware_library_cloudfront_domain" {
  description = "Production labware library CloudFront distribution domain"
  value       = module.labware_library_cloudfront_distribution.distribution_domain_name
}

output "production_labware_library_cloudfront_id" {
  description = "Production labware library CloudFront distribution ID"
  value       = module.labware_library_cloudfront_distribution.distribution_id
}

output "production_labware_library_cloudfront_arn" {
  description = "Production labware library CloudFront distribution ARN"
  value       = module.labware_library_cloudfront_distribution.distribution_arn
}

output "production_labware_library_deployment_url" {
  description = "Production labware library deployment URL"
  value       = "https://${var.labware_library_domain_name}/"
}

output "production_labware_library_origin_access_control_id" {
  description = "Production labware library CloudFront origin access control ID"
  value       = module.labware_library_cloudfront_distribution.origin_access_control_id
}

output "production_protocol_designer_bucket_name" {
  description = "Production protocol designer bucket name"
  value       = module.protocol_designer_bucket.bucket_name
}

output "production_protocol_designer_bucket_arn" {
  description = "Production protocol designer bucket ARN"
  value       = module.protocol_designer_bucket.bucket_arn
}

output "production_protocol_designer_cloudfront_domain" {
  description = "Production protocol designer CloudFront distribution domain"
  value       = module.protocol_designer_cloudfront_distribution.distribution_domain_name
}

output "production_protocol_designer_cloudfront_id" {
  description = "Production protocol designer CloudFront distribution ID"
  value       = module.protocol_designer_cloudfront_distribution.distribution_id
}

output "production_protocol_designer_cloudfront_arn" {
  description = "Production protocol designer CloudFront distribution ARN"
  value       = module.protocol_designer_cloudfront_distribution.distribution_arn
}

output "production_protocol_designer_deployment_url" {
  description = "Production protocol designer deployment URL"
  value       = "https://${var.protocol_designer_domain_name}/"
}

output "production_protocol_designer_certificate_arn" {
  description = "Production protocol designer ACM certificate ARN"
  value       = module.protocol_designer_certificate.certificate_arn
}

output "production_protocol_designer_zone_id" {
  description = "Production protocol designer hosted zone ID"
  value       = aws_route53_zone.protocol_designer.zone_id
}

output "production_protocol_designer_nameservers" {
  description = "Production protocol designer nameservers for delegation"
  value       = aws_route53_zone.protocol_designer.name_servers
}

output "production_components_certificate_arn" {
  description = "Production components ACM certificate ARN"
  value       = module.components_certificate.certificate_arn
}

output "production_components_zone_id" {
  description = "Production components hosted zone ID"
  value       = aws_route53_zone.components.zone_id
}

output "production_components_nameservers" {
  description = "Production components nameservers for delegation"
  value       = aws_route53_zone.components.name_servers
}
