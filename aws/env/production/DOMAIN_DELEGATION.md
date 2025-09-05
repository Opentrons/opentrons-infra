# Domain Delegation Setup for docs.opentrons.com and labware.opentrons.com

## Overview

Both `docs.opentrons.com` and `labware.opentrons.com` subdomains are set up as delegated domains from another AWS account. This document explains how to complete the delegation setup and import existing resources.

## What This Configuration Creates

1. **Hosted Zones**: New Route53 hosted zones for both subdomains in your current account
2. **ACM Certificates**: SSL certificates for both domains (required for CloudFront)
3. **CloudFront Distributions**: CDN distributions for both projects
4. **S3 Buckets**: Storage for both projects

## Important Notes

- **Existing Certificate**: The `var.acm_certificate_arn` variable is no longer used since we now create separate certificates for each domain
- **Delegated Domains**: Both subdomains will be fully delegated to your account, giving you complete control
- **Import Required**: Existing resources must be imported before applying changes

## Delegation Process

### Step 1: Deploy the Infrastructure

After running `terraform apply`, you'll get these outputs:

```bash
# MkDocs domain
terraform output production_mkdocs_nameservers
terraform output production_mkdocs_zone_id

# Labware Library domain
terraform output production_labware_library_nameservers
terraform output production_labware_library_zone_id
```

### Step 2: Get the Nameservers

Both outputs will show 4 nameserver addresses like:
```
[
  "ns-1234.awsdns-12.com",
  "ns-5678.awsdns-34.net",
  "ns-9012.awsdns-56.org",
  "ns-3456.awsdns-78.co.uk"
]
```

### Step 3: Provide Nameservers to the Other Account

The other AWS account (which owns `opentrons.com`) needs to create NS records in their `opentrons.com` hosted zone:

**In the other account's Route53 console:**

1. Go to the `opentrons.com` hosted zone
2. Create NS records for both subdomains:

**For docs.opentrons.com:**
```
Name: docs
Type: NS
Value: [Copy the 4 nameservers from production_mkdocs_nameservers]
```

**For labware.opentrons.com:**
```
Name: labware
Type: NS
Value: [Copy the 4 nameservers from production_labware_library_nameservers]
```

### Step 4: Wait for DNS Propagation

DNS changes can take up to 48 hours to propagate globally, though it usually happens much faster.

## Importing Existing Resources

Since some resources already exist in AWS, you'll need to import them into Terraform state before applying changes.

### Step 1: Identify Existing Resources

Run this to see what resources exist:
```bash
# Check existing S3 buckets
aws s3 ls | grep -E "(docs|labware)"

# Check existing CloudFront distributions
aws cloudfront list-distributions | grep -E "(docs|labware)"

# Check existing ACM certificates
aws acm list-certificates --region us-east-1 | grep -E "(docs|labware)"
```

### Step 2: Import Existing Resources

**Import existing S3 buckets:**
```bash
# Import MkDocs bucket
terraform import module.docs_bucket.aws_s3_bucket.docs <bucket_name>

# Import Labware Library bucket
terraform import module.labware_library_bucket.aws_s3_bucket.docs <bucket_name>
```

**Import existing CloudFront distributions:**
```bash
# Import MkDocs distribution
terraform import module.cloudfront_distribution.aws_cloudfront_distribution.distribution <distribution_id>

# Import Labware Library distribution
terraform import module.labware_library_cloudfront_distribution.aws_cloudfront_distribution.distribution <distribution_id>
```

**Import existing ACM certificates (if they exist):**
```bash
# Import MkDocs certificate
terraform import module.mkdocs_certificate.aws_acm_certificate.cert <certificate_arn>

# Import Labware Library certificate
terraform import module.labware_certificate.aws_acm_certificate.cert <certificate_arn>
```

### Step 3: Verify Imports

Check that resources are imported correctly:
```bash
terraform state list
```

## Verification

### Check Delegation
```bash
# Check if the delegation is working
dig docs.opentrons.com NS
dig labware.opentrons.com NS

# Should return the nameservers from your hosted zones
```

### Check Certificate Validation
```bash
# Check certificate status
aws acm describe-certificate \
  --certificate-arn $(terraform output -raw production_labware_certificate_arn) \
  --region us-east-1
```

## Troubleshooting

### Common Issues

1. **Certificate Validation Fails**
   - Ensure the hosted zone is created before the certificate
   - Check that the Route53 validation records are created correctly

2. **DNS Resolution Issues**
   - Verify NS records are created in the parent `opentrons.com` zone
   - Wait for DNS propagation (can take up to 48 hours)

3. **CloudFront Distribution Fails**
   - Ensure the certificate is validated before creating CloudFront
   - Check that the domain name matches the certificate

### Dependencies

The Terraform configuration ensures proper ordering:
1. **Hosted Zone** → **ACM Certificate** → **CloudFront Distribution**
2. **S3 Bucket** → **CloudFront Distribution**

## Security Considerations

- The delegated zone gives you full control over `labware.opentrons.com`
- Ensure proper IAM permissions for Route53 and ACM operations
- Consider using AWS Organizations for better account management

## Next Steps

After delegation is complete:
1. **Upload content** to the S3 bucket
2. **Test the CloudFront distribution** with the new domain
3. **Monitor DNS resolution** and certificate status
4. **Set up monitoring** for the new infrastructure
