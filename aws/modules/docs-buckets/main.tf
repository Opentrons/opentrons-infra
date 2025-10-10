# Documentation S3 Buckets Module
# This module creates a single S3 bucket for documentation hosting

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Documentation bucket
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  
  tags = merge({
    Name        = "${var.environment}-${var.resource_name}"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}



# Public read access policy for website hosting (conditional)
resource "aws_s3_bucket_policy" "bucket" {
  count  = var.enable_public_access ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.bucket.arn}/*"
      },
    ]
  })
}

# Block public access settings (conditional)
resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = var.enable_public_access ? false : true
  block_public_policy     = var.enable_public_access ? false : true
  ignore_public_acls      = var.enable_public_access ? false : true
  restrict_public_buckets = var.enable_public_access ? false : true
}

# Versioning (conditional)
resource "aws_s3_bucket_versioning" "bucket" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"
  }
}

# Lifecycle rules for cleanup (conditional)
resource "aws_s3_bucket_lifecycle_configuration" "bucket" {
  count  = var.enable_lifecycle_rules ? 1 : 0
  bucket = aws_s3_bucket.bucket.id

  rule {
    id     = "cleanup_old_versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }
  }
}


