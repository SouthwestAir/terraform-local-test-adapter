variable "create_subscription" {
  description = "Determines whether an SNS subscription is created"
  type        = bool
  default     = false
}

variable "endpoint" {
  description = "An email address to use when creating subscription"
  type        = string
  default     = null
}

variable "region" {
  type        = string
  description = "The region to deploy the resources. Only required to initialize the aws provider. This will be set automatically"
}
