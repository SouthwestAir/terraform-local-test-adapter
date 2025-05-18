locals {
  pytest_opts = "--junitxml=${var.junit_xml_file} --json-report --json-report-file=${abspath(path.module)}/pytest.json"
  log_file    = "${abspath(path.module)}/pytest.log"
  pytest_cmd  = var.use_poetry ? "poetry run pytest" : "pytest"
}
resource "null_resource" "run_pytest" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    environment = var.env_vars
    working_dir = var.working_dir
    command     = <<EOT
      rm -f ${local.log_file};
      ${local.pytest_cmd} ${local.pytest_opts} 2>&1 | tee ${local.log_file}
    EOT
  }

}

data "local_file" "pytest_output" {
  depends_on = [null_resource.run_pytest]
  filename   = "${path.module}/pytest.json"
}
data "local_file" "pytest_log" {
  depends_on = [null_resource.run_pytest]
  filename   = "${path.module}/pytest.log"
}
resource "null_resource" "install_poetry_deps" {
  count = var.install_poetry_deps ? 1 : 0

  provisioner "local-exec" {
    command     = "poetry install"
    working_dir = path.module
  }
}
