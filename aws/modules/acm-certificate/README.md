# ACM Certificate Module

This module creates an SSL certificate for CloudFront distributions with automatic DNS validation.

## Features

- **DNS Validation**: Automatic validation using Route53 DNS records
- **Multiple Domains**: Support for subject alternative names
- **Auto-renewal**: Certificates automatically renew before expiration
- **CloudFront Ready**: Certificates created in us-east-1 for CloudFront compatibility

## Usage

```hcl
module "ssl_certificate" {
  source = "../../modules/acm-certificate"
  
  environment = "production"
  domain_name = "docs.opentrons.com"
  subject_alternative_names = ["*.docs.opentrons.com"]
  route53_zone_id = "Z1234567890ABC"
  
  tags = {
    Project = "documentation"
    Team    = "platform"
  }
}

# Use with CloudFront distribution
module "cloudfront" {
  source = "../../modules/cloudfront-distribution"
  
  # ... other configuration ...
  acm_certificate_arn = module.ssl_certificate.certificate_arn
  use_default_certificate = false
  aliases = ["docs.opentrons.com"]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment name | `string` | n/a | yes |
| domain_name | Primary domain name for the certificate | `string` | n/a | yes |
| subject_alternative_names | Additional domain names for the certificate | `list(string)` | `[]` | no |
| route53_zone_id | Route53 hosted zone ID for DNS validation | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| certificate_arn | ARN of the ACM certificate |
| certificate_id | ID of the ACM certificate |
| certificate_domain_name | Domain name of the ACM certificate |
| certificate_status | Status of the ACM certificate |
