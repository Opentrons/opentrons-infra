# Documentation S3 Buckets Module
# This module creates the S3 buckets used for hosting documentation

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Sandbox documentation bucket
resource "aws_s3_bucket" "sandbox_docs" {
  bucket = "sandbox.docs"
  
  tags = {
    Name        = "sandbox-docs"
    Environment = "sandbox"
    Purpose     = "documentation"
    ManagedBy   = "terraform"
  }
}

# Staging documentation bucket
resource "aws_s3_bucket" "staging_docs" {
  bucket = "opentrons.staging.docs"
  
  tags = {
    Name        = "staging-docs"
    Environment = "staging"
    Purpose     = "documentation"
    ManagedBy   = "terraform"
  }
}

# Production documentation bucket
resource "aws_s3_bucket" "production_docs" {
  bucket = "opentrons.production.docs"
  
  tags = {
    Name        = "production-docs"
    Environment = "production"
    Purpose     = "documentation"
    ManagedBy   = "terraform"
  }
}

# Configure website hosting for all buckets
resource "aws_s3_bucket_website_configuration" "sandbox_docs" {
  bucket = aws_s3_bucket.sandbox_docs.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_website_configuration" "staging_docs" {
  bucket = aws_s3_bucket.staging_docs.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_website_configuration" "production_docs" {
  bucket = aws_s3_bucket.production_docs.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Public read access policy for website hosting
resource "aws_s3_bucket_policy" "sandbox_docs" {
  bucket = aws_s3_bucket.sandbox_docs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.sandbox_docs.arn}/*"
      },
    ]
  })
}

resource "aws_s3_bucket_policy" "staging_docs" {
  bucket = aws_s3_bucket.staging_docs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.staging_docs.arn}/*"
      },
    ]
  })
}

resource "aws_s3_bucket_policy" "production_docs" {
  bucket = aws_s3_bucket.production_docs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.production_docs.arn}/*"
      },
    ]
  })
}

# Block public access settings (required for website hosting)
resource "aws_s3_bucket_public_access_block" "sandbox_docs" {
  bucket = aws_s3_bucket.sandbox_docs.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "staging_docs" {
  bucket = aws_s3_bucket.staging_docs.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "production_docs" {
  bucket = aws_s3_bucket.production_docs.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Versioning for all buckets
resource "aws_s3_bucket_versioning" "sandbox_docs" {
  bucket = aws_s3_bucket.sandbox_docs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "staging_docs" {
  bucket = aws_s3_bucket.staging_docs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "production_docs" {
  bucket = aws_s3_bucket.production_docs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Lifecycle rules for cleanup
resource "aws_s3_bucket_lifecycle_configuration" "sandbox_docs" {
  bucket = aws_s3_bucket.sandbox_docs.id

  rule {
    id     = "cleanup_old_versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "staging_docs" {
  bucket = aws_s3_bucket.staging_docs.id

  rule {
    id     = "cleanup_old_versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "production_docs" {
  bucket = aws_s3_bucket.production_docs.id

  rule {
    id     = "cleanup_old_versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}


