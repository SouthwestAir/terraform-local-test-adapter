output "failed_tests" {
  description = "All failed test objects"
  depends_on  = [null_resource.run_pytest]

  value = [for test in jsondecode(data.local_file.pytest_output.content).tests : test if length(regexall(test.outcome, "error|failed")) > 0]
}
output "passed_tests" {
  description = "All passed test objects"
  depends_on  = [null_resource.run_pytest]

  value = [for test in jsondecode(data.local_file.pytest_output.content).tests : test if test.outcome == "passed"]
}
output "log" {
  description = "Pytest log file contents"
  depends_on  = [null_resource.run_pytest]

  value = data.local_file.pytest_log.content
}

locals {
  _parsed   = jsondecode(data.local_file.pytest_output.content)
  _errors   = [for c in local._parsed.collectors : "ERROR ${c.nodeid}\n${try(c.longrepr, "")}" if c.outcome == "error"]
  _failures = [for t in local._parsed.tests : "FAILED ${t.nodeid}\n${try(t.call.longrepr, t.outcome)}" if length(regexall(t.outcome, "error|failed")) > 0]
}

output "failure_summary" {
  description = "Human-readable summary of all test failures and errors"
  depends_on  = [null_resource.run_pytest]
  value       = join("\n\n", concat(local._errors, local._failures))
}
