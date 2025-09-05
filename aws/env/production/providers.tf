provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Provider for ACM certificates (must be in us-east-1 for CloudFront)
provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = var.aws_profile
}
