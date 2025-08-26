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

output "origin_access_control_id" {
  description = "ID of the CloudFront origin access control"
  value       = aws_cloudfront_origin_access_control.oac.id
}

output "origin_access_control_name" {
  description = "Name of the CloudFront origin access control"
  value       = aws_cloudfront_origin_access_control.oac.name
}
