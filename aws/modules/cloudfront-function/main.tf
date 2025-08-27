# CloudFront Function Module
# This module creates a CloudFront function

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# CloudFront function
resource "aws_cloudfront_function" "function" {
  name    = var.function_name
  runtime = var.runtime
  comment = var.comment
  publish = var.publish
  code    = var.function_code
}

# CloudFront function code from file (alternative to inline code)
resource "aws_cloudfront_function" "function_from_file" {
  count   = var.function_code_file != null ? 1 : 0
  name    = var.function_name
  runtime = var.runtime
  comment = var.comment
  publish = var.publish
  code    = file(var.function_code_file)
}
