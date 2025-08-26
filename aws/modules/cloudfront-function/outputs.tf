# Outputs for CloudFront Function Module

output "function_arn" {
  description = "ARN of the CloudFront function"
  value       = aws_cloudfront_function.function.arn
}

output "function_name" {
  description = "Name of the CloudFront function"
  value       = aws_cloudfront_function.function.name
}

output "function_status" {
  description = "Status of the CloudFront function"
  value       = aws_cloudfront_function.function.status
}

output "function_etag" {
  description = "ETag of the CloudFront function"
  value       = aws_cloudfront_function.function.etag
}

# Outputs for function from file (if used)
output "function_from_file_arn" {
  description = "ARN of the CloudFront function created from file"
  value       = length(aws_cloudfront_function.function_from_file) > 0 ? aws_cloudfront_function.function_from_file[0].arn : null
}

output "function_from_file_name" {
  description = "Name of the CloudFront function created from file"
  value       = length(aws_cloudfront_function.function_from_file) > 0 ? aws_cloudfront_function.function_from_file[0].name : null
}
