# Outputs for CloudFront Distribution Module

output "distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.distribution.id
}

output "distribution_arn" {
  description = "ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.distribution.arn
}

output "distribution_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.distribution.domain_name
}

output "distribution_hosted_zone_id" {
  description = "Hosted zone ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.distribution.hosted_zone_id
}

output "distribution_status" {
  description = "Status of the CloudFront distribution"
  value       = aws_cloudfront_distribution.distribution.status
}

output "origin_access_identity_id" {
  description = "ID of the CloudFront origin access identity"
  value       = aws_cloudfront_origin_access_identity.oai.id
}

output "origin_access_identity_arn" {
  description = "ARN of the CloudFront origin access identity"
  value       = aws_cloudfront_origin_access_identity.oai.iam_arn
}

output "origin_access_identity_path" {
  description = "Path of the CloudFront origin access identity"
  value       = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
}
