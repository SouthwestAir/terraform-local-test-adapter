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
