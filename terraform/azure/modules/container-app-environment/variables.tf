variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "UK South"
}

variable "resource_group_name" {
  description = "Resource group for Container App Environment"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "ID of Log Analytics Workspace"
  type        = string
}
