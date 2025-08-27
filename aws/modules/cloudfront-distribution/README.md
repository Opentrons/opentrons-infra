# CloudFront Distribution Module

This module creates a CloudFront distribution for S3 bucket hosting with configurable settings.

## Usage

```hcl
module "cloudfront" {
  source = "../../modules/cloudfront-distribution"
  
  environment         = "production"
  origin_domain_name  = module.docs_buckets.website_endpoint
  origin_id           = "s3-docs-bucket"
  s3_bucket_id        = module.docs_buckets.bucket_name
  s3_bucket_arn       = module.docs_buckets.bucket_arn
  
  # Optional: Custom domain
  aliases = ["docs.example.com"]
  
  # Optional: Function associations
  function_associations = [
    {
      event_type   = "viewer-request"
      function_arn = module.cloudfront_function.function_arn
    }
  ]
  
  tags = {
    Project = "documentation"
    Team    = "platform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment name | `string` | n/a | yes |
| enabled | Whether the distribution is enabled | `bool` | `true` | no |
| origin_domain_name | Domain name of the origin (S3 bucket) | `string` | n/a | yes |
| origin_id | Unique identifier for the origin | `string` | n/a | yes |
| s3_bucket_id | S3 bucket ID | `string` | n/a | yes |
| s3_bucket_arn | S3 bucket ARN | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| distribution_id | ID of the CloudFront distribution |
| distribution_arn | ARN of the CloudFront distribution |
| distribution_domain_name | Domain name of the CloudFront distribution |
| origin_access_identity_arn | ARN of the CloudFront origin access identity |
