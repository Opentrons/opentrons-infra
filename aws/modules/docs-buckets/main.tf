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
resource "aws_s3_bucket" "docs" {
  bucket = var.bucket_name
  
  tags = merge({
    Name        = "${var.environment}-docs"
    Environment = var.environment
    ManagedBy   = "terraform"
  }, var.tags)
}

# Configure website hosting
resource "aws_s3_bucket_website_configuration" "docs" {
  bucket = aws_s3_bucket.docs.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

# Public read access policy for website hosting
resource "aws_s3_bucket_policy" "docs" {
  bucket = aws_s3_bucket.docs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.docs.arn}/*"
      },
    ]
  })
}

# Block public access settings (required for website hosting)
resource "aws_s3_bucket_public_access_block" "docs" {
  bucket = aws_s3_bucket.docs.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Versioning (conditional)
resource "aws_s3_bucket_versioning" "docs" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.docs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Lifecycle rules for cleanup (conditional)
resource "aws_s3_bucket_lifecycle_configuration" "docs" {
  count  = var.enable_lifecycle_rules ? 1 : 0
  bucket = aws_s3_bucket.docs.id

  rule {
    id     = "cleanup_old_versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_version_expiration_days
    }
  }
}


