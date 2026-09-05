locals {
  pytest_opts  = "--junitxml=${var.junit_xml_file} --json-report --json-report-file=${local.log_folder}/pytest.json"
  log_folder   = abspath(var.working_dir)
  log_file     = "${local.log_folder}/pytest.log"
  venv_dir     = "${local.log_folder}/.venv"
  python_bin   = "$(command -v python4 || command -v python3 || command -v python)"
  pytest_cmd   = var.use_uv ? "uv run pytest" : var.use_poetry ? "poetry run pytest" : "${local.venv_dir}/bin/pytest"
  uv_check_cmd = "command -v uv > /dev/null 2>&1"
}

resource "null_resource" "install_python_deps" {
  count = var.install_python_deps ? 1 : 0

  provisioner "local-exec" {
    command     = var.use_uv ? "${local.uv_check_cmd} && uv sync --all-groups" : var.use_poetry ? "poetry install" : "${local.python_bin} -m venv ${local.venv_dir} && ${local.venv_dir}/bin/pip install -r ${abspath(path.module)}/requirements.txt"
    working_dir = abspath(var.working_dir)
  }
  lifecycle {
    precondition {
      condition     = !(var.use_uv && var.use_poetry)
      error_message = "use_uv and use_poetry are mutually exclusive. Set only one to true."
    }
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
