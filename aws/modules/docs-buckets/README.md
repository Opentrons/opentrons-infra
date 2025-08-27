# Documentation S3 Buckets Terraform Module

This Terraform module creates and configures the S3 buckets used for hosting Opentrons documentation across different environments.

## Overview

The module creates three S3 buckets:
- **sandbox.docs** - For sandbox/preview documentation
- **opentrons.staging.docs** - For staging documentation  
- **opentrons.production.docs** - For production documentation

## Features

- ✅ S3 bucket creation with proper naming
- ✅ Website hosting configuration
- ✅ Public read access policies
- ✅ Versioning enabled
- ✅ Lifecycle rules for cleanup
- ✅ Proper tagging
- ✅ Public access block settings for website hosting

## Usage

### Basic Usage

```hcl
module "docs_buckets" {
  source = "./modules/docs-buckets"
  
  environment = "production"
  aws_region  = "us-east-2"
  
  tags = {
    Project     = "opentrons-docs"
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

### Advanced Usage

```hcl
module "docs_buckets" {
  source = "./modules/docs-buckets"
  
  environment = "staging"
  aws_region  = "us-east-2"
  
  enable_versioning = true
  enable_lifecycle_rules = true
  noncurrent_version_expiration_days = 30
  
  tags = {
    Project     = "opentrons-docs"
    Environment = "staging"
    Team        = "platform"
    CostCenter  = "engineering"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | AWS region where the buckets will be created | `string` | `"us-east-2"` | no |
| environment | Environment name (sandbox, staging, production) | `string` | n/a | yes |
| enable_versioning | Enable versioning on the buckets | `bool` | `true` | no |
| enable_lifecycle_rules | Enable lifecycle rules for cleanup | `bool` | `true` | no |
| noncurrent_version_expiration_days | Number of days after which noncurrent versions are deleted | `number` | `30` | no |
| tags | Additional tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| sandbox_bucket_name | Name of the sandbox documentation bucket |
| sandbox_bucket_arn | ARN of the sandbox documentation bucket |
| sandbox_website_endpoint | Website endpoint for the sandbox documentation bucket |
| staging_bucket_name | Name of the staging documentation bucket |
| staging_bucket_arn | ARN of the staging documentation bucket |
| staging_website_endpoint | Website endpoint for the staging documentation bucket |
| production_bucket_name | Name of the production documentation bucket |
| production_bucket_arn | ARN of the production documentation bucket |
| production_website_endpoint | Website endpoint for the production documentation bucket |
| all_bucket_names | Names of all documentation buckets |
| all_bucket_arns | ARNs of all documentation buckets |
| all_website_endpoints | Website endpoints for all documentation buckets |

## Bucket Configuration

### Website Hosting
All buckets are configured for static website hosting with:
- Index document: `index.html`
- Error document: `error.html`

### Public Access
- Public read access is enabled for website hosting
- Public access blocks are configured to allow website hosting

### Versioning
- Versioning is enabled on all buckets
- Lifecycle rules clean up old versions after 30 days (configurable)

### Bucket Policies
Each bucket has a policy allowing public read access for website hosting:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::bucket-name/*"
    }
  ]
}
```

## Deployment URLs

After deployment, the documentation will be available at:

- **Sandbox**: `http://sandbox.docs.s3-website.us-east-2.amazonaws.com/`
- **Staging**: `https://staging.docs.opentrons.com/` (with CloudFront)
- **Production**: `https://docs.opentrons.com/` (with CloudFront)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.0 |

## License

This module is part of the Opentrons infrastructure and follows the same licensing terms.


