module "this" {
  source = "../../"

  working_dir = abspath(path.module)
  env_vars = {
    AWS_REGION = "us-east-1"
  }
  junit_xml_file = ""
}
