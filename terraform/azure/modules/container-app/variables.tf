variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for Container App"
  type        = string
}

variable "environment_id" {
  description = "ID of the Container App Environment"
  type        = string
}

variable "container_image" {
  description = "Container image to deploy"
  type        = string
  default     = "nginx:latest"
}

variable "cpu" {
  description = "CPU for container"
  type        = number
  default     = 0.5
}

variable "memory" {
  description = "Memory for container"
  type        = string
  default     = "1.0Gi"
}

variable "target_port" {
  description = "Port to expose"
  type        = number
  default     = 80
}

variable "container_name" {
  description = "Name of the container"
  type        = string
  default     = "app"
}
