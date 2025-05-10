tflint {
  required_version = ">= 0.50"
}

plugin "terraform" {
  enabled = true
  preset  = "all"
}

plugin "aws" {
  enabled = true
  version = "0.33.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}
rule "terraform_standard_module_structure" {
  enabled = false
}
rule "terraform_required_version" {
  enabled = false
}
