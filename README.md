# Terraform Test Runner Adapter

A Terraform module that provides a unified interface for running different test frameworks within Terraform test.

## Supported Test Frameworks

- Jest (JavaScript/TypeScript) 🃏
- Pytest (Python) 🐍
- k6 (Performance Testing) ⏩

[See examples](https://github.com/SouthwestAir/terraform-local-test-adapter/tree/main/examples)

## Features

- Supports pytest, jest, and k6 test execution. 🛠️
- Provides structured test results as Terraform outputs. 🏢
- Designed for use within terraform test to enable infrastructure integration testing. 🏗️  🔬

## How it works

[Diagram GitHub Link](https://raw.githubusercontent.com/SouthwestAir/terraform-local-test-adapter/main/docs/source/diagram.png)
![x](https://raw.githubusercontent.com/SouthwestAir/terraform-local-test-adapter/main/docs/source/diagram.png)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >1.10.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.4.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.3 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_jest"></a> [jest](#module\_jest) | ./modules/jest | n/a |
| <a name="module_k6"></a> [k6](#module\_k6) | ./modules/k6 | n/a |
| <a name="module_pytest"></a> [pytest](#module\_pytest) | ./modules/pytest | n/a |

## Resources

No resources.

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
| <a name="output_failed_tests"></a> [failed\_tests](#output\_failed\_tests) | All failed tests |
| <a name="output_log"></a> [log](#output\_log) | Log file contents |
| <a name="output_passed_tests"></a> [passed\_tests](#output\_passed\_tests) | All passed tests |
<!-- END_TF_DOCS -->
