output "failed_tests" {
  description = "All failed test objects"
  value       = [for assertion in jsondecode(local_file.jest_asserts.content) : assertion if assertion.status != "passed"]
}
output "passed_tests" {
  description = "All passed test objects"
  value       = [for assertion in jsondecode(local_file.jest_asserts.content) : assertion if assertion.status == "passed"]
}

output "log" {
  description = "Jest log file contents"
  value       = data.local_file.jest_log.content
}
