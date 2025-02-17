# Terraform/Terragrunt Module Development

Check [CCP Next Documentation](https://southwest.gitlab-dedicated.com/swa-common/devplat/ccp-next/ccp-next-documentation) to get yourself familiar with CCP Next projects.

> :warning: check [aws-resource-names](https://southwest.gitlab-dedicated.com/swa-common/devplat/ccp-next/ccp-next-documentation/-/blob/master/docs/best_practices/ccp_next_best_practices.md?ref_type=heads#aws-resource-names) and [aws-resource-tags](https://southwest.gitlab-dedicated.com/swa-common/devplat/ccp-next/ccp-next-documentation/-/blob/master/docs/best_practices/ccp_next_best_practices.md?ref_type=heads#aws-resource-tags) for SWA/CCP Next AWS resource naming and tagging conventions. This is important for consistency throughout the organization. Using [ccp-next-labels-module](https://southwest.gitlab-dedicated.com/swa-common/devplat/ccp-next/ccp-next-incubator/modules/ccp-next-labels-module) will make it easier for you to ensure you are naming and tagging AWS resources consistently.

<!-- mdformat-toc start --slug=gitlab --no-anchors --maxlevel=6 --minlevel=2 -->

- [Terraform/Terragrunt Module Development](#terraformterragrunt-module-development)
  - [Getting Started](#getting-started)
  - [TL;DR](#tldr)
  - [Terraform Files Organization](#terraform-files-organization)
  - [Tagging](#tagging)
  - [Terraform Tests](#terraform-tests)
  - [`local/` Directory *(recommended)*](#local-directory-recommended)
  - [`examples/full_config_options/full.auto.tfvars` *(recommended)*](#examplesfull_config_optionsfullautotfvars-recommended)
  - [`examples/minimal_config_options/minimal.auto.tfvars` *(recommended)*](#examplesminimal_config_optionsminimalautotfvars-recommended)
  - [Local Deployment](#local-deployment)
  - [Useful CCP Next Document Links](#useful-ccp-next-document-links)

<!-- mdformat-toc end -->

## Getting Started

Make sure you are familiar with [CCP Next Module Projects](https://southwest.gitlab-dedicated.com/swa-common/devplat/ccp-next/ccp-next-documentation/-/tree/master/docs/ccp_next/module?ref_type=heads).

To get your local environment setup activate your venv (nvm/pyenv etc.) and run:

```sh
> make setup
```

To find more info about how to interact with the project run:

```sh
> make help
```

Check inline docs for both [./Makefile](./Makefile) and `./.general-resources.mk` which will be there after you have run `make setup` to find more customization options.

## TL;DR

The template provides a starting point for Terraform/Terragrunt modules and comes pre-configured to create and publish Terraform/Terragrunt modules on Southwest [Gitlab Terraform Module Registry](https://docs.gitlab.com/ee/user/packages/terraform_module_registry/).

Check out the details for the files that matters the most for this project apart from some CCP common files.

```sh
.
├── .pre-commit-config.yaml           # (recommended) pre-commit config to make sure you are always pushing standard code.  also used to generate docs automatically
├── .tarball-exclusions               # (optional) list of files/paths that will not be part of the packaged module that will be published
├── .terraform-docs.yaml              # (recommended) configuration for terraform-docs
├── .tflint.hcl                       # (optional) configuration for tflint if you want to override the defaults
├── CONTRIBUTING.md                   # developers guide
├── datasources.tf                    # (optional) tf data sources
├── examples                          # (optional) example for using the module
│   ├── full_config_options           # (optional) example showing full config options
│   │   └── ...
│   └── minimal_config_options        # (optional) example showing minimal config options
│       └── ...
├── local                             # (optional) dir containing required tf config for local deployments and smoke testing. not used in pipelines
│   ├── defaults.auto.tfvars          # (optional) deployment input variables
│   ├── locals.tf                     # (optional) tf local vars
│   ├── main.tf                       # (recommended) tf main processes. this file is also used in the README.md to show a working example.
│   │                                 # check .terraform-docs.yml configuration
│   ├── outputs.tf                    # (optional) tf outputs
│   ├── provider.tf                   # (optional) tf providers
│   ├── variables.tf                  # (optional) deployments tf vars
│   └── versions.tf                   # (optional) tf provider versions
├── locals.tf                         # (optional) module locals
├── main.tf                           # module main processes
├── Makefile                          # run `make help` for all customization options
├── outputs.tf                        # module outputs
├── README.md                         # module documentation. auto-generated when using terraform-docs and pre-commit. check .terraform-docs.yml configuration
├── tf-<namespace>-plan.out           # (auto-generated) tf plan out file to be used by deploy/destroy make targets. not checked into git
├── tf-<namespace>-plan-checkov.json  # (auto-generated) local files for checkov-iac-scan make target. not checked into git
├── tests                             # (strongly recommended) dir containing tests for module. run with `terraform test`
│   ├── setup                         # (optional) tf test setup dir. any tf files will be applied as part of setup test phase
│   │   ├── main.tf                   # (optional) test setup main processes
│   │   ├── outputs.tf                # (optional) test setup outputs
│   │   └── variables.tf              # (optional) test variables
│   ├── full.auto.tfvars              # (recommended) all supported input variables for the module. this file is also used in the README.md to show a working example.
│   │                                 # check .terraform-docs.yml configuration. also used for tests automatically as filename ends with .auto.tfvars
│   ├── min.tfvars                    # (recommended) minimal input variables requirement for the module. this file is also used in the README.md to show a working example.
│   │                                 # check .terraform-docs.yml configuration
│   └── unit.tftest.hcl               # (optional) tests to run. all file names should end with `.tftest.hcl`
├── variables.tf                      # module vars
└── versions.tf                       # module required provider versions
```

## Terraform Files Organization

It is expected that your directory structure match what is outlined in this project. This is not a functional requirement, but it will make using this repository easier. If a `main.tf` file is not present in the root (e.g. all infrastructure is in a `terraform/` directory), additional arguments will need to be supplied.

## Tagging

Apart from using [ccp-next-labels-module](https://southwest.gitlab-dedicated.com/swa-common/devplat/ccp-next/ccp-next-incubator/modules/ccp-next-labels-module) CCP Next recommends using the following tags as well for better maintenance and troubleshooting.

```terraform
# file: variables.tf

variable "module_name" {
  type        = string
  default     = "_MODULE_NAME_"
  description = "The name of this module. DO NOT change var name or the default value. This will be set automatically"
}

variable "module_version" {
  type        = string
  default     = "_MODULE_VERSION_"
  description = "The version of this module. DO NOT change var name or the default value. This will be set automatically"
}
```

And use them in your resource tags like:

```terraform
tags = merge(module.root_labels.tags, { CCPModuleVersion = var.module_version }, { CCPModuleName = var.module_name })
```

These tags make troubleshooting issues easier.

## Terraform Tests

Tests are located in [./tests](./tests) directory. For more information check official page: <https://developer.hashicorp.com/terraform/language/tests>.

There is no current integration with Integration Framework (iTest Accounts). You will have to mock your providers and/or resources to run Terraform test. CCP may add integration to the iTest Framework if there is a need in the future.

Check [CCP Next Terraform Tests](https://southwest.gitlab-dedicated.com/swa-common/devplat/ccp-next/ccp-next-documentation/-/blob/master/docs/ccp_next/iac_security_and_reliability.md?ref_type=heads#terraform-test-highly-recommended) for more details.

## [`local/`](./local/) Directory *(recommended)*

Instead of just documenting examples on how to use the module, it is recommended to include a *fully functional* set of deployment configurations under the [`local/`](./local/) directory.

This directory is intended for local development, allowing for smoke testing and validating integrations with other services.

For example, if you are creating an EKS module that needs to be deployed in a specially configured VPC, the [`local/`](./local/) folder should include those VPC configurations. You can utilize a VPC module to deploy and configure the VPC, making it easier for future developers to test their changes without having to set up or reconfigure the necessary infrastructure. This *configure once* approach improves the efficiency of module development, ensuring the [`local/`](./local/) directory is ready to deploy without any issues for anyone working on the module.

Check [./local/README.md](./local/README.md) for more information.

Check [.terraform-docs.yml](./.terraform-docs.yml) configuration on how the [local/main.tf](./local/main.tf) file is being used to document working examples.

## [`examples/full_config_options/full.auto.tfvars`](./examples/full_config_options/full.auto.tfvars) *(recommended)*

[`examples/full_config_options/full.auto.tfvars`](./examples/full_config_options/full.auto.tfvars) is used automatically for running Terraform tests as the filename ends with `.auto.tfvars`. This file is also used to document [Full Config](./README.md#full-config) *(all supported input variables by the module)*.

Check [.terraform-docs.yml](./.terraform-docs.yml) configuration on how the [`examples/full_config_options/full.auto.tfvars`](./examples/full_config_options/full.auto.tfvars) file is being used to document [Full Config](./README.md#full-config).

## [`examples/minimal_config_options/minimal.auto.tfvars`](./examples/minimal_config_options/minimal.auto.tfvars) *(recommended)*

[`examples/minimal_config_options/minimal.auto.tfvars`](./examples/minimal_config_options/minimal.auto.tfvars) is ***not*** used automatically for running Terraform tests. This file is rather used to document [Minimal Config](./README.md#minimal-config) *(minimum required input variables for the module to function)*.

Check [.terraform-docs.yml](./.terraform-docs.yml) configuration on how the [`examples/minimal_config_options/minimal.auto.tfvars`](./examples/minimal_config_options/minimal.auto.tfvars) file is being used to document [Minimal Config](./README.md#full-config).

## Local Deployment

Local deployment configs should be placed in [local/](./local/). These configs are only used for local deployments and smoke testing. They are not used in pipelines in any ways. Check [./local/README.md](./local/README.md) for more information.

To deploy this module to your development or lab account, follow these steps:

1. Log into Your AWS Account:

   - Use AWS SAML to log into the AWS account of your choice. Ensure your credentials file is correctly configured and credentials are exported as needed.
   - For detailed instructions on logging in and setting up your credentials, refer to the [AWS SAML Documentation](https://docs.awssaml.ec.dev.aws.swacorp.com/index.html).

1. Run Make Commands:

   - The local deployment process involves running a series of `make` commands:
     - `make init`: This command initializes the Terraform configuration, setting up the backend and preparing the environment.
     - `make plan`: This command creates an execution plan, allowing you to review the changes Terraform will make to your infrastructure. You can run this with `OPTS_TF_PLAN=-destroy` to generate a plan for removing your infra.
     - `make deploy`: This command applies the execution plan, deploying the infrastructure changes to your AWS account.
     - `make destroy`: This command destroys the infrastructure.

## Useful CCP Next Document Links

- [ccp-next-labels-module](https://southwest.gitlab-dedicated.com/swa-common/devplat/ccp-next/ccp-next-modules/ccp-next-labels-module)
- [Local Environment Setup](https://southwest.gitlab-dedicated.com/swa-common/devplat/ccp-next/ccp-next-documentation/-/tree/master/docs/local?ref_type=heads)
- [CCP Next Best Practices](https://southwest.gitlab-dedicated.com/swa-common/devplat/ccp-next/ccp-next-documentation/-/tree/master/docs/best_practices?ref_type=heads)
- [CCP Next Policies](https://southwest.gitlab-dedicated.com/swa-common/devplat/ccp-next/ccp-next-documentation/-/tree/master/docs/ccp_next/policies?ref_type=heads)
