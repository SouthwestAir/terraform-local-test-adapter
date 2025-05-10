module "this" {
  source = "../../"

  working_dir    = abspath(path.module)
  env_vars       = {}
  junit_xml_file = "junit.xml"
}
