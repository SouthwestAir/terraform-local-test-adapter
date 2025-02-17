terraform {
  # floor version must match from the local module
  required_version = ">= 1.7.0, < 2.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # must match from the local module
      version = "~> 5.27.0"
    }
  }
  backend "s3" {}
}
