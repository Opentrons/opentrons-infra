# Variables for CloudFront Distribution Module

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "enabled" {
  description = "Whether the distribution is enabled"
  type        = bool
  default     = true
}

variable "is_ipv6_enabled" {
  description = "Whether the distribution is IPv6 enabled"
  type        = bool
  default     = true
}

variable "comment" {
  description = "Comment for the distribution"
  type        = string
  default     = ""
}

variable "default_root_object" {
  description = "Default root object for the distribution"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "Price class for the distribution"
  type        = string
  default     = "PriceClass_100"
  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.price_class)
    error_message = "Price class must be one of: PriceClass_100, PriceClass_200, PriceClass_All."
  }
}

variable "aliases" {
  description = "Aliases for the distribution"
  type        = list(string)
  default     = []
}

variable "origin_domain_name" {
  description = "Domain name of the origin (S3 bucket)"
  type        = string
}

variable "origin_id" {
  description = "Unique identifier for the origin"
  type        = string
}

variable "custom_user_agent" {
  description = "Custom User-Agent header value (set to empty string to disable)"
  type        = string
  default     = ""
}

variable "allowed_methods" {
  description = "Allowed HTTP methods"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "cached_methods" {
  description = "Cached HTTP methods"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "forward_query_string" {
  description = "Whether to forward query strings"
  type        = bool
  default     = false
}

variable "forward_cookies" {
  description = "How to forward cookies"
  type        = string
  default     = "none"
  validation {
    condition     = contains(["none", "whitelist", "all"], var.forward_cookies)
    error_message = "Forward cookies must be one of: none, whitelist, all."
  }
}

variable "viewer_protocol_policy" {
  description = "Viewer protocol policy"
  type        = string
  default     = "redirect-to-https"
  validation {
    condition     = contains(["allow-all", "https-only", "redirect-to-https"], var.viewer_protocol_policy)
    error_message = "Viewer protocol policy must be one of: allow-all, https-only, redirect-to-https."
  }
}

variable "min_ttl" {
  description = "Minimum TTL in seconds"
  type        = number
  default     = 0
}

variable "default_ttl" {
  description = "Default TTL in seconds"
  type        = number
  default     = 86400
}

variable "max_ttl" {
  description = "Maximum TTL in seconds"
  type        = number
  default     = 31536000
}

variable "compress" {
  description = "Whether to compress objects"
  type        = bool
  default     = true
}

variable "function_associations" {
  description = "CloudFront function associations"
  type = list(object({
    event_type   = string
    function_arn = string
  }))
  default = []
}

variable "custom_error_responses" {
  description = "Custom error responses"
  type = list(object({
    error_code            = number
    response_code         = optional(number)
    response_page_path    = optional(string)
    error_caching_min_ttl = optional(number)
  }))
  default = []
}

variable "geo_restriction_type" {
  description = "Geo restriction type"
  type        = string
  default     = "none"
  validation {
    condition     = contains(["none", "whitelist", "blacklist"], var.geo_restriction_type)
    error_message = "Geo restriction type must be one of: none, whitelist, blacklist."
  }
}

variable "geo_restriction_locations" {
  description = "Geo restriction locations"
  type        = list(string)
  default     = []
}

variable "use_default_certificate" {
  description = "Whether to use the default CloudFront certificate"
  type        = bool
  default     = true
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for custom domain"
  type        = string
  default     = null
}

variable "ssl_support_method" {
  description = "SSL support method"
  type        = string
  default     = "sni-only"
  validation {
    condition     = contains(["sni-only", "vip"], var.ssl_support_method)
    error_message = "SSL support method must be one of: sni-only, vip."
  }
}

variable "minimum_protocol_version" {
  description = "Minimum protocol version"
  type        = string
  default     = "TLSv1.2_2021"
}

variable "web_acl_id" {
  description = "WAF Web ACL ID to associate with the CloudFront distribution"
  type        = string
  default     = null
}

variable "s3_bucket_id" {
  description = "S3 bucket ID"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket ARN"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "project" {
  description = "Project name for unique resource naming"
  type        = string
  default     = null
}

variable "origin_access_control_name" {
  description = "Name for the Origin Access Control (must be unique within the account)"
  type        = string
  default     = null
}

variable "origin_access_control_description" {
  description = "Description for the Origin Access Control"
  type        = string
  default     = null
}

variable "create_s3_bucket_policy" {
  description = "Whether to create the S3 bucket policy for CloudFront access"
  type        = bool
  default     = true
}
