terraform {
  required_version = ">1.10.0"
  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.3"
    }
    # tflint-ignore: terraform_unused_required_providers
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4.0"
    }
  }
}
