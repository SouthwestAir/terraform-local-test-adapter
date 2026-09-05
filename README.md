# Terraform Test Runner Adapter

A Terraform module that provides a unified interface for running different test frameworks within `terraform test`.

## Supported Test Frameworks

- Jest (JavaScript/TypeScript)
- Pytest (Python)
- k6 (Performance Testing) [alpha]

[See examples](https://github.com/SouthwestAir/terraform-local-test-adapter/tree/main/examples)

## Features

- Supports pytest, jest, and k6 test execution.
- Provides structured test results as Terraform outputs.
- Designed for use within `terraform test` to enable infrastructure integration testing.
- Optional runtime dependency installation via pip, Poetry, or uv.

## How it works

[Diagram GitHub Link](https://raw.githubusercontent.com/SouthwestAir/terraform-local-test-adapter/main/docs/source/diagram.png)
![x](https://raw.githubusercontent.com/SouthwestAir/terraform-local-test-adapter/main/docs/source/diagram.png)

## Failure Output

When tests fail, the error message surfaces the test name and failure details directly in `terraform test` output — no raw JSON or log noise.

![Failure example](https://raw.githubusercontent.com/SouthwestAir/terraform-local-test-adapter/main/docs/source/fail_example.png)

## Usage

### Basic pytest (pre-installed dependencies)

```hcl
module "tests" {
  source = "github.com/SouthwestAir/terraform-local-test-adapter"

  working_dir    = path.module
  junit_xml_file = "junit.xml"
}
```

### Pytest with uv

Uses `uv run pytest` and optionally runs `uv sync --all-groups` before the test run. Requires a `pyproject.toml` and `uv.lock` in `working_dir`.

```hcl
module "tests" {
  source = "github.com/SouthwestAir/terraform-local-test-adapter"

  working_dir         = path.module
  use_uv              = true
  install_python_deps = true
  junit_xml_file      = "junit.xml"
}
```

### Pytest with Poetry

```hcl
module "tests" {
  source = "github.com/SouthwestAir/terraform-local-test-adapter"

  working_dir         = path.module
  use_poetry          = true
  install_python_deps = true
  junit_xml_file      = "junit.xml"
}
```

### Jest

```hcl
module "tests" {
  source = "github.com/SouthwestAir/terraform-local-test-adapter"

  working_dir    = path.module
  junit_xml_file = "junit.xml"
}
```

### k6

```hcl
module "tests" {
  source = "github.com/SouthwestAir/terraform-local-test-adapter"

  working_dir = path.module
  env_vars = {
    AWS_REGION = "us-east-1"
  }
}
```

### Passing environment variables

```hcl
module "tests" {
  source = "github.com/SouthwestAir/terraform-local-test-adapter"

  working_dir = path.module
  env_vars = {
    API_URL    = "https://my-api.example.com"
    AWS_REGION = "us-east-1"
  }
}
```

## Dependency Installation

Set `install_python_deps = true` to have the module install Python dependencies before running tests.

| Tool | Behavior |
|------|----------|
| Default (pip) | Creates a `.venv` in `working_dir` and installs from `requirements.txt` |
| `use_poetry = true` | Runs `poetry install` in `working_dir` |
| `use_uv = true` | Runs `uv sync --all-groups` in `working_dir` (requires `pyproject.toml` + `uv.lock`) |

`use_uv` and `use_poetry` are mutually exclusive.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >1.9.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.0.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module_jest"></a> [jest](#module\_jest) | ./modules/jest | n/a |
| <a name="module_k6"></a> [k6](#module\_k6) | ./modules/k6 | n/a |
| <a name="module_pytest"></a> [pytest](#module\_pytest) | ./modules/pytest | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default |
| ---- | ----------- | ---- | ------- |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | Environment variables for test runner | `map(string)` | `{}` |
| <a name="input_framework"></a> [framework](#input\_framework) | Explicitly choose framework to run | `string` | `""` |
| <a name="input_install_python_deps"></a> [install\_python\_deps](#input\_install\_python\_deps) | Install Python dependencies at runtime using Poetry/pip/uv if not already installed | `bool` | `false` |
| <a name="input_junit_xml_file"></a> [junit\_xml\_file](#input\_junit\_xml\_file) | Path for junit xml output file | `string` | `"junit.xml"` |
| <a name="input_use_poetry"></a> [use\_poetry](#input\_use\_poetry) | Use poetry run | `bool` | `false` |
| <a name="input_use_uv"></a> [use\_uv](#input\_use\_uv) | Use uv run | `bool` | `false` |
| <a name="input_working_dir"></a> [working\_dir](#input\_working\_dir) | Dir with tests | `string` | `"."` |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_failed_tests"></a> [failed\_tests](#output\_failed\_tests) | All failed tests |
| <a name="output_failure_summary"></a> [failure\_summary](#output\_failure\_summary) | Human-readable summary of test failures |
| <a name="output_log"></a> [log](#output\_log) | Log file contents |
| <a name="output_passed_tests"></a> [passed\_tests](#output\_passed\_tests) | All passed tests |
<!-- END_TF_DOCS -->
