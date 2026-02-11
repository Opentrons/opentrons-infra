# Variables for Production Environment

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-2"
}

variable "aws_profile" {
  description = "AWS profile to use"
  type        = string
  default     = "robotics-protocol-library-prod-root"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "project" {
  description = "Project name (e.g., mkdocs, labware)"
  type        = string
  default     = "mkdocs"
}

variable "domain_name" {
  description = "Domain name for the documentation site"
  type        = string
  default     = "docs.opentrons.com"
}

variable "labware_library_domain_name" {
  description = "Domain name for the labware library site"
  type        = string
  default     = "labware.opentrons.com"
}

variable "mkdocs_bucket_name" {
  description = "S3 bucket name for MkDocs documentation"
  type        = string
  default     = "opentrons.production.docs"
}

variable "labware_library_bucket_name" {
  description = "S3 bucket name for labware library"
  type        = string
  default     = "opentrons.production.labware"
}

variable "protocol_designer_domain_name" {
  description = "Domain name for the protocol designer site"
  type        = string
  default     = "designer.opentrons.com"
}

variable "protocol_designer_bucket_name" {
  description = "S3 bucket name for protocol designer"
  type        = string
  default     = "opentrons.production.designer"
}

variable "ot2_protocol_designer_bucket_name" {
  description = "S3 bucket name for ot2 protocol designer (separate infra)"
  type        = string
  default     = "opentrons.production.designer.ot2"
}

variable "ot2_labware_library_bucket_name" {
  description = "S3 bucket name for ot2 labware library (separate infra)"
  type        = string
  default     = "opentrons.production.labware.ot2"
}

variable "components_domain_name" {
  description = "Domain name for the components site"
  type        = string
  default     = "components.opentrons.com"
}

variable "components_bucket_name" {
  description = "S3 bucket name for components"
  type        = string
  default     = "opentrons.production.components"
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "enable_lifecycle_rules" {
  description = "Enable S3 lifecycle rules"
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Days to keep noncurrent versions"
  type        = number
  default     = 30
}

variable "cloudfront_function_arn" {
  description = "ARN of the CloudFront function for index redirect"
  type        = string
  default     = "arn:aws:cloudfront::043748923082:function/indexRedirect"
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for the domain"
  type        = string
  default     = "arn:aws:acm:us-east-1:043748923082:certificate/ddb7db56-f29e-4f1f-87a3-09f9cf0fb70c"
}

variable "web_acl_id" {
  description = "WAF Web ACL ID to associate with the CloudFront distribution"
  type        = string
  default     = "arn:aws:wafv2:us-east-1:043748923082:global/webacl/CreatedByCloudFront-d198945c/a5351067-a055-4830-8622-8a6d645910a3"
}
