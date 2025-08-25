# Opentrons Infrastructure Environments

This directory contains environment-specific Terraform configurations for the Opentrons infrastructure.

## Environment Files

### `sandbox.tf`
- **Purpose**: Sandbox/preview environment for testing and development
- **Bucket**: `sandbox.docs`
- **URL**: `http://sandbox.docs.s3-website.us-east-2.amazonaws.com/`
- **Retention**: 7 days for noncurrent versions
- **Use Case**: Feature branch deployments, testing new documentation

### `staging.tf`
- **Purpose**: Staging environment for pre-production testing
- **Bucket**: `opentrons.staging.docs`
- **URL**: `https://staging.docs.opentrons.com/`
- **Retention**: 14 days for noncurrent versions
- **Use Case**: Release candidate testing, staging deployments

### `production.tf`
- **Purpose**: Production environment for live documentation
- **Bucket**: `opentrons.production.docs`
- **URL**: `https://docs.opentrons.com/`
- **Retention**: 30 days for noncurrent versions
- **Use Case**: Live documentation hosting

## Usage

### Deploy to Sandbox
```bash
cd environments
terraform workspace select sandbox
terraform init
terraform plan -target=module.docs_buckets
terraform apply -target=module.docs_buckets
```

### Deploy to Staging
```bash
cd environments
terraform workspace select staging
terraform init
terraform plan -target=module.docs_buckets
terraform apply -target=module.docs_buckets
```

### Deploy to Production
```bash
cd environments
terraform workspace select production
terraform init
terraform plan -target=module.docs_buckets
terraform apply -target=module.docs_buckets
```

## Environment-Specific Settings

Each environment has different configurations optimized for its purpose:

| Environment | Version Retention | Lifecycle Rules | Purpose |
|-------------|------------------|-----------------|---------|
| Sandbox     | 7 days           | Enabled         | Testing & Development |
| Staging     | 14 days          | Enabled         | Pre-production Testing |
| Production  | 30 days          | Enabled         | Live Documentation |

## Outputs

Each environment file provides relevant outputs:

- `{environment}_bucket_name` - S3 bucket name
- `{environment}_bucket_arn` - S3 bucket ARN
- `{environment}_website_endpoint` - S3 website endpoint
- `{environment}_deployment_url` - Final deployment URL

## Security

All environments use the same security configurations:
- Public read access for website hosting
- Versioning enabled for rollback capability
- Lifecycle rules for cost management
- Proper tagging for resource tracking

## Dependencies

These environment files depend on the `../modules/docs-buckets` module, which provides:
- S3 bucket creation and configuration
- Website hosting setup
- Public access policies
- Versioning and lifecycle management

