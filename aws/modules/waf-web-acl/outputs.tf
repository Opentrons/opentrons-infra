# Outputs for WAF Web ACL Module

output "web_acl_id" {
  description = "ID of the WAF Web ACL"
  value       = aws_wafv2_web_acl.main.id
}

output "web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = aws_wafv2_web_acl.main.arn
}

output "web_acl_name" {
  description = "Name of the WAF Web ACL"
  value       = aws_wafv2_web_acl.main.name
}

output "web_acl_description" {
  description = "Description of the WAF Web ACL"
  value       = aws_wafv2_web_acl.main.description
}
