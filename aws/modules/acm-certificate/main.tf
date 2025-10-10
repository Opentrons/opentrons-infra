# ACM Certificate Module
# This module creates an SSL certificate for CloudFront distributions

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ACM Certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = var.subject_alternative_names

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({
    Name        = "${var.environment}-cert"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

# Certificate validation records
resource "aws_route53_record" "validation" {
  for_each = var.create_validation ? {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

# Certificate validation
resource "aws_acm_certificate_validation" "cert" {
  count = var.create_validation ? 1 : 0
  
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = var.create_validation ? [for record in aws_route53_record.validation : record.fqdn] : []
}
