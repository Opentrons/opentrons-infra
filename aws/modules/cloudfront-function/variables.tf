# Variables for CloudFront Function Module

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "function_name" {
  description = "Name of the CloudFront function"
  type        = string
}

variable "runtime" {
  description = "Runtime for the CloudFront function"
  type        = string
  default     = "cloudfront-js-1.0"
  validation {
    condition     = contains(["cloudfront-js-1.0"], var.runtime)
    error_message = "Runtime must be cloudfront-js-1.0."
  }
}

variable "comment" {
  description = "Comment for the CloudFront function"
  type        = string
  default     = ""
}

variable "publish" {
  description = "Whether to publish the function"
  type        = bool
  default     = true
}

variable "function_code" {
  description = "JavaScript code for the CloudFront function"
  type        = string
  default     = null
}

variable "function_code_file" {
  description = "Path to JavaScript file containing the CloudFront function code"
  type        = string
  default     = null
}
