# file: local/provider.tf

provider "aws" {
  region = var.region

  default_tags {
    tags = module.root_labels.tags
  }
}
