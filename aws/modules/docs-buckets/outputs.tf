# Outputs for Documentation S3 Buckets Module

output "bucket_name" {
  description = "Name of the documentation bucket"
  value       = aws_s3_bucket.bucket.bucket
}

output "bucket_arn" {
  description = "ARN of the documentation bucket"
  value       = aws_s3_bucket.bucket.arn
}




