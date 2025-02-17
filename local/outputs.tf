output "sns_topic_arn" {
  value       = module.root.sns_topic_arn
  description = "SNS topic ARN created from the local SNS module."
}
