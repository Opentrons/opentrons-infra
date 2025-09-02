# Variables for Staging Environment

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
  default     = "staging"
}

variable "domain_name" {
  description = "Domain name for the documentation site"
  type        = string
  default     = "staging.docs.opentrons.com"
}

variable "mkdocs_bucket_name" {
  description = "S3 bucket name for MkDocs documentation"
  type        = string
  default     = "opentrons.staging.docs"
}

variable "labware_library_bucket_name" {
  description = "S3 bucket name for labware library"
  type        = string
  default     = "opentrons.staging.labware.library"
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
  default     = 14
}

variable "cloudfront_function_arn" {
  description = "ARN of the CloudFront function for index redirect"
  type        = string
  default     = "arn:aws:cloudfront::043748923082:function/indexRedirect"
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for the domain"
  type        = string
  default     = "arn:aws:acm:us-east-1:043748923082:certificate/5edbb417-cdbd-4fbc-8f19-18fbc169c531"
}

variable "web_acl_id" {
  description = "WAF Web ACL ID to associate with the CloudFront distribution"
  type        = string
  default     = null
}
