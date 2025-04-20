variable "subscription_id" {
  description = "Azure Subscription ID to deploy into"
  type        = string
  default     = "b86f730d-9e28-4dcc-957b-191526d42b14"
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "aca"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "UK South"
}
