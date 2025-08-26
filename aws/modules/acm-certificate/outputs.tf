# Outputs for ACM Certificate Module

output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.cert.arn
}

output "certificate_id" {
  description = "ID of the ACM certificate"
  value       = aws_acm_certificate.cert.id
}

output "certificate_domain_name" {
  description = "Domain name of the ACM certificate"
  value       = aws_acm_certificate.cert.domain_name
}

output "certificate_status" {
  description = "Status of the ACM certificate"
  value       = aws_acm_certificate.cert.status
}

output "certificate_validation_status" {
  description = "Status of the certificate validation"
  value       = aws_acm_certificate_validation.cert.certificate_arn
}
