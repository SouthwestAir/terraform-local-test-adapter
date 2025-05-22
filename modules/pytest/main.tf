locals {
  pytest_opts = "--junitxml=${var.junit_xml_file} --json-report --json-report-file=${local.log_folder}/pytest.json"
  log_folder  = abspath(var.working_dir)
  log_file    = "${local.log_folder}/pytest.log"
  pytest_cmd  = var.use_poetry ? "poetry run pytest" : "pytest"
}

resource "null_resource" "install_python_deps" {
  count = var.install_python_deps ? 1 : 0

  provisioner "local-exec" {
    command     = var.use_poetry ? "poetry install" : "pip install -r ${abspath(path.module)}/requirements.txt"
    working_dir = path.module
  }
}

resource "null_resource" "run_pytest" {
  depends_on = [
    null_resource.install_python_deps,
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
  filename   = "${local.log_folder}/pytest.json"
}
data "local_file" "pytest_log" {
  depends_on = [null_resource.run_pytest]
  filename   = "${local.log_folder}/pytest.log"
}
