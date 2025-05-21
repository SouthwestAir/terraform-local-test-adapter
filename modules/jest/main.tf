locals {
  log_folder        = abspath(path.root)
  default_jest_opts = "--ci --reporters=default --reporters=jest-junit --json --outputFile=${local.log_folder}/jest.json --roots ${var.working_dir}"
}
resource "null_resource" "run_jest" {
  provisioner "local-exec" {
    environment = merge({ JEST_JUNIT_OUTPUT_NAME = var.junit_xml_file }, var.env_vars)
    working_dir = var.working_dir
    command     = <<EOT
      rm -f ${local.log_folder}/jest.json;
      rm -f ${local.log_folder}/jest.log;
      npx jest ${local.default_jest_opts} 2>&1 | tee ${local.log_folder}/jest.log
    EOT
  }
}


data "local_file" "jest_log" {
  depends_on = [null_resource.run_jest]
  filename   = "${local.log_folder}/jest.log"
}
data "local_file" "jest_json" {
  depends_on = [null_resource.run_jest]
  filename   = "${local.log_folder}/jest.json"
}

resource "local_file" "jest_asserts" {
  depends_on = [null_resource.run_jest]
  filename   = "${local.log_folder}/_jest_asserts.json"
  content = jsonencode(flatten([
    try(jsondecode(data.local_file.jest_json.content).testResults[*].assertionResults, [])
  ]))
}
