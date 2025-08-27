# CloudFront Function Module

This module creates a CloudFront function for edge computing.

## Usage

### Inline Function Code

```hcl
module "cloudfront_function" {
  source = "../../modules/cloudfront-function"
  
  environment    = "production"
  function_name  = "security-headers"
  function_code  = <<-EOF
    function handler(event) {
      var response = event.response;
      var headers = response.headers;
      
      // Add security headers
      headers['x-content-type-options'] = {value: 'nosniff'};
      headers['x-frame-options'] = {value: 'DENY'};
      headers['x-xss-protection'] = {value: '1; mode=block'};
      headers['referrer-policy'] = {value: 'strict-origin-when-cross-origin'};
      
      return response;
    }
  EOF
  
  tags = {
    Project = "documentation"
    Team    = "platform"
  }
}
```

### Function Code from File

```hcl
module "cloudfront_function" {
  source = "../../modules/cloudfront-function"
  
  environment         = "production"
  function_name       = "security-headers"
  function_code_file  = "functions/security-headers.js"
  
  tags = {
    Project = "documentation"
    Team    = "platform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment name | `string` | n/a | yes |
| function_name | Name of the CloudFront function | `string` | n/a | yes |
| function_code | JavaScript code for the CloudFront function | `string` | `null` | no |
| function_code_file | Path to JavaScript file containing the CloudFront function code | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| function_arn | ARN of the CloudFront function |
| function_name | Name of the CloudFront function |
| function_status | Status of the CloudFront function |
