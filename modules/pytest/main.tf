data "aws_region" "current" {}
locals {
  pytest_opts = "--junitxml=report.xml --json-report --json-report-file=./pytest.json"
}
resource "null_resource" "run_pytest" {
  provisioner "local-exec" {
    environment = var.env_vars
    working_dir = var.working_dir
    command     = <<EOT
      pytest ${local.pytest_opts} | tee > ./pytest.log 2>&1
    EOT
  }
}

data "local_file" "pytest_output" {
  depends_on = [null_resource.run_pytest]
  filename   = "${var.working_dir}/pytest.json"
}
data "local_file" "pytest_log" {
  depends_on = [null_resource.run_pytest]
  filename   = "${var.working_dir}/pytest.log"
}

locals {
  all_tests = jsondecode(data.local_file.pytest_output.content).tests
}

output "pytest_output" {
  value = jsondecode(data.local_file.pytest_output.content)
}

output "failed_tests" {
  value = [for test in local.all_tests : test if length(regexall(test.outcome, "error|failed")) > 0]
}
output "passed_tests" {
  value = [for test in local.all_tests : test if test.outcome == "passed"]
}
output "log" {
  value = data.local_file.pytest_log.content
}
