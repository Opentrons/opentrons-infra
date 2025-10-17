# Variables for Sandbox Environment

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
  default     = "sandbox"
}

variable "domain_name" {
  description = "Domain name for the documentation site"
  type        = string
  default     = "sandbox.docs.opentrons.com"
}

variable "bucket_name" {
  description = "S3 bucket name for documentation"
  type        = string
  default     = "sandbox.docs"
}

variable "labware_library_domain_name" {
  description = "Domain name for the labware library site"
  type        = string
  default     = "sandbox.labware.opentrons.com"
}

variable "labware_library_bucket_name" {
  description = "S3 bucket name for labware library"
  type        = string
  default     = "opentrons.sandbox.labware"
}

variable "protocol_designer_domain_name" {
  description = "Domain name for the protocol designer site"
  type        = string
  default     = "sandbox.designer.opentrons.com"
}

variable "protocol_designer_bucket_name" {
  description = "S3 bucket name for protocol designer"
  type        = string
  default     = "opentrons.sandbox.designer"
}

variable "components_domain_name" {
  description = "Domain name for the components site"
  type        = string
  default     = "sandbox.components.opentrons.com"
}

variable "components_bucket_name" {
  description = "S3 bucket name for components"
  type        = string
  default     = "opentrons.sandbox.components"
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
  default     = 7
}

variable "cloudfront_function_arn" {
  description = "ARN of the CloudFront function for index redirect"
  type        = string
  default     = "arn:aws:cloudfront::043748923082:function/indexRedirect"
}

variable "web_acl_id" {
  description = "WAF Web ACL ID to associate with the CloudFront distribution"
  type        = string
  default     = null
}

