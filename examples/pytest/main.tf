module "this" {
  source = "../../modules/pytest"

  working_dir         = abspath(path.module)
  env_vars            = {}
  junit_xml_file      = "junit.xml"
  use_poetry          = var.use_poetry
  install_poetry_deps = var.install_poetry_deps
}
variable "use_poetry" {
  type        = bool
  description = "Use poetry run"
  default     = false
}
variable "install_poetry_deps" {
  description = "Install Python dependencies at runtime using Poetry if not already installed"
  type        = bool
  default     = false
  validation {
    condition     = var.install_poetry_deps ? var.use_poetry : true
    error_message = "If install_poetry_deps is true than use poetry should also be true"
  }
}
