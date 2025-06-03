test {
  parallel = false
}

run "pytest" {
  state_key = "pytest-1"
  module {
    source = "./examples/pytest"
  }
  variables {
    use_poetry          = false
    install_python_deps = true
  }
  assert {
    condition     = length(module.this.passed_tests) == 1
    error_message = module.this.log
  }
}

run "pytest_install_deps" {
  state_key = "pytest-1"
  module {
    source = "./examples/pytest"
  }
  variables {
    use_poetry          = true
    install_python_deps = true
  }
}
run "pytest_failure" {
  variables {
    working_dir = "./tests/pytest_failure"
    use_poetry  = true
  }
  expect_failures = [
    check.failures
  ]
}
run "k6" {
  module {
    source = "./examples/k6"
  }
  assert {
    condition     = length(module.this.failed_tests) == 0
    error_message = module.this.log
  }
}

run "jest" {
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

run "jest_failure" {
  state_key = "jest-failure"
  variables {
    working_dir = "./tests/jest_failure"
  }
  expect_failures = [
    check.failures
  ]
}
