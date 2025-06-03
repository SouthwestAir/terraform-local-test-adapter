module "pytest" {
  count          = var.framework == "pytest" || length(fileset(var.working_dir, "test_*.py")) == 0 ? 0 : 1
  source         = "./modules/pytest"
  working_dir    = var.working_dir
  env_vars       = var.env_vars
  junit_xml_file = var.junit_xml_file
}

module "jest" {
  count          = var.framework == "jest" || length(fileset(var.working_dir, "*.{test,spec}.{ts,js}")) == 0 ? 0 : 1
  source         = "./modules/jest"
  working_dir    = var.working_dir
  env_vars       = var.env_vars
  junit_xml_file = var.junit_xml_file
}
module "k6" {
  count          = var.framework == "k6" || length(fileset(var.working_dir, "*.{k6}.{ts,js}")) == 0 ? 0 : 1
  source         = "./modules/k6"
  working_dir    = var.working_dir
  env_vars       = var.env_vars
  junit_xml_file = var.junit_xml_file
}

locals {
  module = try(module.pytest[0], module.k6[0], module.jest[0])
}
check "failures" {

  assert {
    condition     = !can(regex("ERROR", local.module.log)) && length(local.module.failed_tests) == 0
    error_message = "${local.module.log}\n${jsonencode(local.module.failed_tests)}"
  }
}
