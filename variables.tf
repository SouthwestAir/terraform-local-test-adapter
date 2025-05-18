variable "working_dir" {
  type        = string
  description = "Dir with tests"
  default     = "."
}
variable "env_vars" {
  type        = map(string)
  default     = {}
  description = "Environment variables for test runner"
}
# tflint-ignore: terraform_unused_declarations
variable "junit_xml_file" {
  type        = string
  default     = "junit.xml"
  description = "Path for junit xml output file"
}
# tflint-ignore: terraform_unused_declarations
variable "framework" {
  description = "Explicitly choose framework to run"
  type        = string
  default     = ""
  validation {
    condition     = contains(["jest", "pytest", "k6", ""], var.framework)
    error_message = "Can be one of: jest, pytest, k6, \"\""
  }
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
