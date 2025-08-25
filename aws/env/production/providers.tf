provider "aws" {
  profile = "robotics-protocol-library-prod-root"
  alias   = "robotics-protocol-library-prod"

  region = "us-east-2"

  default_tags {
    tags = {
      ou = "robotics"
    }
  }
}
