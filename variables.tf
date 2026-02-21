variable "project_name" {
  description = "Project name"
  type        = string
  default     = "ap-design-ai"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "node_count" {
  description = "Initial system node count"
  type        = number
  default     = 2
}
