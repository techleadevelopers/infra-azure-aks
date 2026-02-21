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

variable "admin_ip" {
  description = "IP authorized to access the AKS API server (CIDR, e.g., 1.2.3.4/32)"
  type        = string
}

variable "node_count" {
  description = "Initial system node count"
  type        = number
  default     = 2
}
