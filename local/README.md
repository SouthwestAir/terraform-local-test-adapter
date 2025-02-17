# local

This directory holds terraform configurations for local deployments and smoke testing AWS resources.

A working example for module usage should be added in this directory as examples for users.

No terraform lock files should be checked in from this `local` directory. Each time a new development and local deployment is taking place it will create a new lock file to ensure that all the providers are working with latest dependency resolution.

You can also add other modules (Gitlab terraform modules) as needed if you want to smoke test integration with other services.

## Local Deployments

Check [Local Deployment](../CONTRIBUTING.md#local-deployment) to get started.

You can export `REGION`, `AWS_REGION` or `AWS_DEFAULT_REGION` to your desired region to deploy in different regions.

<!-- BEGIN_TF_DOCS -->

## Special Inputs

Following input variables will be set with automations. You do not have to set them in any `tfvars` file.

1. `environment`
1. `namespace`
1. `region` - Only required to initialize the `aws` provider if it is not explicitly listed for the module inputs.
1. `repo_id`
1. `state_bucket`
1. `state_key`

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.0, < 2.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.27.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_root"></a> [root](#module\_root) | ../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| <a name="input_region"></a> [region](#input\_region) | The region to deploy the resources. Only required to initialize the aws provider. This will be set automatically | `string` | n/a |
| <a name="input_create_subscription"></a> [create\_subscription](#input\_create\_subscription) | Determines whether an SNS subscription is created | `bool` | `false` |
| <a name="input_endpoint"></a> [endpoint](#input\_endpoint) | An email address to use when creating subscription | `string` | `null` |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | SNS topic ARN created from the local SNS module. |
<!-- END_TF_DOCS -->
