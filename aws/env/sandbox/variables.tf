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

