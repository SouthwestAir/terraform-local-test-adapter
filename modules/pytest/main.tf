locals {
  pytest_opts = "--junitxml=${var.junit_xml_file} --json-report --json-report-file=${abspath(path.module)}/pytest.json"
  log_file    = "${abspath(path.module)}/pytest.log"
  pytest_cmd  = var.use_poetry ? "poetry run pytest" : "pytest"
}

resource "null_resource" "install_poetry_deps" {
  count = var.install_poetry_deps ? 1 : 0

  provisioner "local-exec" {
    command     = "command -v poetry >/dev/null 2>&1 && poetry install || pip install -r requirements.txt"
    working_dir = path.module
  }
}

resource "null_resource" "check_pytest_deps" {
  count = var.install_poetry_deps ? 0 : 1

  provisioner "local-exec" {
    command = <<EOT
      python3 -c "import pytest" 2>/dev/null || (echo 'pytest not found. Set install_poetry_deps = true or run poetry install.' && exit 1)
    EOT
  }
}
resource "null_resource" "run_pytest" {
  depends_on = [
    null_resource.install_poetry_deps,
    null_resource.check_pytest_deps
  ]
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
