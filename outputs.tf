output "failed_tests" {
  description = "All failed tests"
  value       = try(module.jest[0], module.pytest[0], module.k6[0]).failed_tests
}
output "log" {
  description = "Log file contents"
  value       = try(module.jest[0], module.pytest[0], module.k6[0]).log
}
output "passed_tests" {
  description = "All passed tests"
  value       = try(module.jest[0], module.pytest[0], module.k6[0]).passed_tests
}
output "failure_summary" {
  description = "Human-readable summary of test failures"
  value       = try(module.jest[0], module.pytest[0], module.k6[0]).failure_summary
}
