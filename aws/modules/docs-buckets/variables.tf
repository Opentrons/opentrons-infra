# Variables for Documentation S3 Buckets Module

variable "bucket_name" {
  description = "Name of the S3 bucket to create"
  type        = string
}

variable "aws_region" {
  description = "AWS region where the buckets will be created"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Environment name (sandbox, staging, production)"
  type        = string
  validation {
    condition     = contains(["sandbox", "staging", "production"], var.environment)
    error_message = "Environment must be one of: sandbox, staging, production."
  }
}

variable "enable_public_access" {
  description = "Enable public read access to the bucket (for direct website hosting)"
  type        = bool
  default     = true
}

variable "enable_versioning" {
  description = "Enable versioning on the buckets"
  type        = bool
  default     = true
}

variable "enable_lifecycle_rules" {
  description = "Enable lifecycle rules for cleanup"
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Number of days after which noncurrent versions are deleted"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}


