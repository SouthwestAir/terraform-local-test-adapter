output "log" {
  value       = data.local_file.k6_log.content
  description = "K6 log"
}
output "failed_tests" {
  value       = strcontains(data.local_file.k6_log.content, "error") ? [1] : []
  description = "Any errors"
}

output "passed_tests" {
  value       = []
  description = "Not Applicable"
}

output "failure_summary" {
  description = "Human-readable summary of errors"
  value       = strcontains(data.local_file.k6_log.content, "error") ? "ERROR: k6 reported errors. See log output." : ""
}
