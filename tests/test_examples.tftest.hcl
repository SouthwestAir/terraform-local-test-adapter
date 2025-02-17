provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      integration_test = "yes"
    }
  }
}


run "jest" {
  command = apply

  module {
    source = "./examples/jest"
  }
  assert {
    condition     = length(output.failed_tests) == 1
    error_message = output.log
  }
  assert {
    condition     = length(output.passed_tests) == 1
    error_message = output.log
  }
}
run "pytest" {
  command = apply

  module {
    source = "./examples/pytest"
  }
  assert {
    condition     = length(output.failed_tests) == 0
    error_message = output.log
  }
  assert {
    condition     = length(output.passed_tests) == 1
    error_message = output.log
  }
}
