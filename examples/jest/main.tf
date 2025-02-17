module "this" {
  source = "../../"

  working_dir = path.module
  env_vars = {
    AWS_REGION = "us-east-1"
  }
}
output "failed_tests" {
  value = module.this.failed_tests
}

output "log" {
  value = module.this.log
}
output "passed_tests" {
  value = module.this.passed_tests
}
