variables {
  junit_xml_file = "junit_1.xml"

}
test {
  parallel = true
}
run "jest" {
  command = apply
  module {
    source = "./examples/jest"
  }
  assert {
    condition     = length(module.this.failed_tests) == 0
    error_message = module.this.log
  }
  assert {
    condition     = length(module.this.passed_tests) == 2 && fileexists("./examples/jest/junit.xml")
    error_message = module.this.log
  }
}
run "k6" {
  command = apply

  module {
    source = "./examples/k6"
  }
  assert {
    condition     = length(module.this.failed_tests) == 0
    error_message = module.this.log
  }

}

run "pytest" {
  command = apply
  module {
    source = "./examples/pytest"
  }
  variables {
    use_poetry = true
  }
  assert {
    condition     = length(module.this.failed_tests) == 0
    error_message = module.this.log
  }
  assert {
    condition     = length(module.this.passed_tests) == 1
    error_message = module.this.log
  }
}

run "pytest_install_deps" {
  command = apply
  module {
    source = "./examples/pytest"
  }
  variables {
    use_poetry          = true
    install_poetry_deps = true
  }
  assert {
    condition     = length(module.this.failed_tests) == 0
    error_message = module.this.log
  }
}
run "pytest_failure" {
  command = apply
  variables {
    working_dir = "./tests/pytest_failure"
  }
  expect_failures = [
    check.failures
  ]
}
run "jest_failure" {
  command = apply
  variables {
    working_dir = "./tests/jest_failure"
  }
  expect_failures = [
    check.failures
  ]
}
