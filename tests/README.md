# Terraform Tests

Run `make test` which in turn runs `terraform test` to test the module.

You can test the module either by mocking the providers and/or resources or against ephemeral AWS resources.

This module and CCP Nxt pipelines currently only support testing with mocking the providers and/or resources.
