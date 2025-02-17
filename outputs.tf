output "failed_tests" {
  value = coalesce(one(module.jest[*].failed_tests), one(module.pytest[*].failed_tests))
}

output "log" {
  value = coalesce(one(module.jest[*].log), one(module.pytest[*].log))

}
output "passed_tests" {
  value = coalesce(one(module.jest[*].passed_tests), one(module.pytest[*].passed_tests))

}
