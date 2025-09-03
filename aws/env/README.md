# AWS Environment Configuration

This directory contains the Terraform configurations for different AWS environments (sandbox, staging, production) used by Opentrons.

## Environments

### Sandbox
- **Purpose**: Development and testing environment
- **Domain**: `sandbox.docs.opentrons.com`
- **S3 Buckets**:
  - `sandbox.docs` - MkDocs documentation hosting
  - `sandbox.labware` - Labware library storage
- **CloudFront**: Enabled with custom domain
- **WAF**: Not configured

### Staging
- **Purpose**: Pre-production testing environment
- **Domain**: `staging.docs.opentrons.com`
- **S3 Buckets**:
  - `opentrons.staging.docs` - MkDocs documentation hosting
  - `opentrons.staging.labware` - Labware library storage
- **CloudFront**: Enabled with custom domain
- **WAF**: Not configured

### Production
- **Purpose**: Live production environment
- **Domain**: `docs.opentrons.com`
- **S3 Buckets**:
  - `opentrons.production.docs` - MkDocs documentation hosting
  - `opentrons.production.labware` - Labware library storage
- **CloudFront**: Enabled with custom domain
- **WAF**: Configured with Web ACL

## Labware Library Buckets

New S3 buckets have been added for the labware library project across all environments:

- **Sandbox**: `sandbox.labware`
- **Staging**: `opentrons.staging.labware`
- **Production**: `opentrons.production.labware`

These buckets are configured with:
- Versioning enabled
- Lifecycle rules for cleanup (7-30 days depending on environment)
- Public access blocked (CloudFront only access)
- Consistent tagging with `Project = "opentrons-labware-library"`
- Same security and compliance settings as documentation buckets

## Modules Used

- **docs-buckets**: Creates S3 buckets with consistent configuration
- **cloudfront-distribution**: Sets up CloudFront distributions for S3 hosting
- **waf-web-acl**: Configures WAF rules (production only)
- **acm-certificate**: Manages SSL certificates
- **cloudfront-function**: Handles index redirects

## Configuration

Each environment has its own:
- `variables.tf` - Environment-specific variables
- `terraform.tfvars.example` - Example configuration values
- `terraform.tf` - Backend and provider configuration
- Main configuration file (e.g., `sandbox.tf`, `staging.tf`, `production.tf`)

## Usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars`
2. Customize values as needed
3. Run `terraform init` to initialize
4. Run `terraform plan` to review changes
5. Run `terraform apply` to apply changes

## Security Features

- S3 buckets are private with CloudFront-only access
- SSL/TLS encryption enforced
- WAF protection in production
- Consistent tagging for resource management
- Lifecycle rules for cost optimization

