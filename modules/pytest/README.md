# Pytest

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >1.10.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.4.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | >= 2.4.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.2.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.install_python_deps](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.run_pytest](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [local_file.pytest_log](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.pytest_output](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | Environment variables for test runner | `map(string)` | `{}` |
| <a name="input_framework"></a> [framework](#input\_framework) | Explicitly choose framework to run | `string` | `""` |
| <a name="input_install_python_deps"></a> [install\_python\_deps](#input\_install\_python\_deps) | Install Python dependencies at runtime using Poetry/pip if not already installed | `bool` | `false` |
| <a name="input_junit_xml_file"></a> [junit\_xml\_file](#input\_junit\_xml\_file) | Path for junit xml output file | `string` | `"junit.xml"` |
| <a name="input_use_poetry"></a> [use\_poetry](#input\_use\_poetry) | Use poetry run | `bool` | `false` |
| <a name="input_working_dir"></a> [working\_dir](#input\_working\_dir) | Dir with tests | `string` | `"."` |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_failed_tests"></a> [failed\_tests](#output\_failed\_tests) | All failed test objects |
| <a name="output_log"></a> [log](#output\_log) | Pytest log file contents |
| <a name="output_passed_tests"></a> [passed\_tests](#output\_passed\_tests) | All passed test objects |
<!-- END_TF_DOCS -->
