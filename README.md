# opentrons-infra
Opentrons monorepo Infra

## Overview

This repository contains the infrastructure as code for Opentrons using Terraform. The infrastructure is organized into environment-specific configurations located in the `aws/env/` directory.

## Directory Structure

```
aws/
├── modules/          # Reusable Terraform modules
│   ├── docs-buckets/
│   ├── cloudfront-distribution/
│   ├── cloudfront-function/
│   └── waf-web-acl/
└── env/              # Environment-specific configurations
    ├── sandbox/      # Development/testing environment
    ├── staging/      # Pre-production environment
    └── production/   # Production environment
```

## Prerequisites

Before running Terraform commands, ensure you have:

1. **Terraform installed** (version ~>1.11)
2. **AWS CLI configured** with appropriate credentials
3. **AWS profile configured** for Terraform state management (`terraform-state` profile)
4. **Access to the S3 backend** (`core-infra-tf-state` bucket in us-east-2)

## Running Terraform Commands

### Environment Setup

Each environment directory (`aws/env/sandbox`, `aws/env/staging`, `aws/env/production`) contains its own Terraform configuration with:

- `terraform.tf` - Backend configuration and provider requirements
- `{environment}.tf` - Environment-specific resources
- `.terraform.lock.hcl` - Provider lock file

### Common Terraform Workflow

Navigate to the desired environment directory and follow these steps:

```bash
# 1. Navigate to the environment directory
cd aws/env/sandbox    # or staging, production

# 2. Initialize Terraform (downloads providers and sets up backend)
terraform init

# 3. Plan your changes
terraform plan

# 4. Apply your changes
terraform apply
```

### Environment-Specific Commands

#### Sandbox Environment
```bash
cd aws/env/sandbox
terraform init
terraform plan
terraform apply
```

#### Staging Environment
```bash
cd aws/env/staging
terraform init
terraform plan
terraform apply
```

#### Production Environment
```bash
cd aws/env/production
terraform init
terraform plan
terraform apply
```

### Targeting Specific Resources

To deploy only specific resources or modules:

```bash
# Deploy only the docs buckets module
terraform plan -target=module.docs_buckets
terraform apply -target=module.docs_buckets

# Deploy only specific resources
terraform plan -target=aws_s3_bucket.docs
terraform apply -target=aws_s3_bucket.docs
```

### State Management

The Terraform state is stored remotely in S3 with the following configuration:
- **Backend**: S3
- **Bucket**: `core-infra-tf-state`
- **Region**: `us-east-2`
- **Profile**: `terraform-state`
- **Encryption**: Enabled

### Useful Commands

```bash
# Check current state
terraform show

# List resources
terraform state list

# Import existing resources
terraform import aws_s3_bucket.docs bucket-name

# Destroy resources (use with caution)
terraform destroy

# Format Terraform files
terraform fmt

# Validate configuration
terraform validate

# Refresh state
terraform refresh
```

### Best Practices

1. **Always run `terraform plan`** before applying changes
2. **Review changes carefully** before applying to production
3. **Keep state files secure** and never commit them to version control
4. **Use consistent naming** for resources across environments
5. **Document changes** in commit messages

### Troubleshooting

#### Common Issues

1. **Backend configuration errors**: Ensure AWS credentials are properly configured
2. **Provider version conflicts**: Check `.terraform.lock.hcl` for version constraints
3. **State lock issues**: Check if another process is holding the state lock
4. **Permission errors**: Verify AWS IAM permissions for the terraform-state profile

#### Getting Help

- Check the environment-specific README in `aws/env/README.md`
- Review Terraform logs for detailed error messages
- Ensure all required AWS services are available in your region

## Security Notes

- All environments use proper IAM roles and policies
- S3 buckets are configured with appropriate access controls
- State files are encrypted and stored securely
- Follow the principle of least privilege when configuring access

## Contributing

When making changes to infrastructure:

1. Test changes in sandbox first
2. Use descriptive commit messages
3. Update documentation as needed
4. Follow the existing naming conventions
5. Ensure all Terraform files are properly formatted
