module "this" {
  source = "../../modules/pytest"

  working_dir         = abspath(path.module)
  env_vars            = {}
  junit_xml_file      = "junit.xml"
  use_poetry          = var.use_poetry
  install_python_deps = var.install_python_deps
}
variable "use_poetry" {
  type        = bool
  description = "Use poetry run"
  default     = false
}
variable "install_python_deps" {
  description = "Install Python dependencies at runtime using Poetry/pip if not already installed"
  type        = bool
  default     = false
}
