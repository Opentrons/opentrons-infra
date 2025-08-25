terraform {
  required_version = "~>1.11"
  required_providers {
    aws = { source = "hashicorp/aws"
    version = "~> 5.74.0" }
  }
  backend "s3" {
    profile      = "terraform-state"
    region       = "us-east-2"
    bucket       = "core-infra-tf-state"
    use_lockfile = true
    key          = "opentrons/staging/terraform.tfstate"
    encrypt      = true
  }
}
