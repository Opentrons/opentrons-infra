# WAF Web ACL Module

This module creates a WAF Web ACL for protecting CloudFront distributions with comprehensive security rules.

## Features

- **Rate Limiting**: Configurable rate limiting per IP address
- **AWS Managed Rules**: Multiple AWS managed rule sets for common threats
- **Logging**: Optional logging to S3 via Kinesis Firehose
- **CloudWatch Metrics**: Built-in monitoring and metrics

## Usage

```hcl
module "waf_web_acl" {
  source = "../../modules/waf-web-acl"
  
  environment = "production"
  rate_limit  = 2000  # 2000 requests per 5 minutes per IP
  
  tags = {
    Project = "documentation"
    Team    = "platform"
  }
}

# Use with CloudFront distribution
module "cloudfront" {
  source = "../../modules/cloudfront-distribution"
  
  # ... other configuration ...
  web_acl_id = module.waf_web_acl.web_acl_id
}
```

## Included Rule Sets

1. **Rate Limiting**: Blocks IPs that exceed the rate limit
2. **Common Rule Set**: Protects against common web vulnerabilities
3. **Known Bad Inputs**: Blocks known malicious inputs
4. **SQL Injection**: Protects against SQL injection attacks
5. **Linux OS**: Protects against Linux-specific attacks
6. **Windows OS**: Protects against Windows-specific attacks

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment name | `string` | n/a | yes |
| rate_limit | Rate limit for requests per 5 minutes per IP | `number` | `2000` | no |
| enable_logging | Enable WAF logging to S3 | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| web_acl_id | ID of the WAF Web ACL |
| web_acl_arn | ARN of the WAF Web ACL |
| web_acl_name | Name of the WAF Web ACL |
