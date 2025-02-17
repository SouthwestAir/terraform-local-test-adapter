data "aws_region" "current" {}
locals {
  jest_opts = "--json --outputFile=./jest.json ${var.working_dir}"
}
resource "null_resource" "run_jest" {
  provisioner "local-exec" {
    environment = var.env_vars
    working_dir = var.working_dir
    command     = <<EOT
      npx jest ${local.jest_opts} 2>&1 | tee ./jest.log
    EOT
  }
}

data "local_file" "jest_log" {
  depends_on = [null_resource.run_jest]
  filename   = "${var.working_dir}/jest.log"
}
data "local_file" "jest_json" {
  depends_on = [null_resource.run_jest]
  filename   = "${var.working_dir}/jest.json"
}

locals {
  all_assertions = flatten([
    jsondecode(data.local_file.jest_json.content).testResults[*].assertionResults
  ])
}

output "failed_tests" {
  value = [for assertion in local.all_assertions : assertion if assertion.status != "passed"]
}
output "passed_tests" {
  value = [for assertion in local.all_assertions : assertion if assertion.status == "passed"]
}

output "log" {
  value = data.local_file.jest_log.content
}
