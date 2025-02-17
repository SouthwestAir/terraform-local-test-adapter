module "pytest" {
  count       = length(fileset(var.working_dir, "*.py")) == 0 ? 0 : 1
  source      = "./modules/pytest"
  working_dir = var.working_dir
  env_vars    = var.env_vars
}

module "jest" {
  count       = length(fileset(var.working_dir, "*.spec.{ts,js}")) == 0 ? 0 : 1
  source      = "./modules/jest"
  working_dir = var.working_dir
  env_vars    = var.env_vars
}
