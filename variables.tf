variable "project_name" {
  description = "Nome do projeto usado nos recursos Azure"
  type        = string
  default     = "ap-design-ai"
}

variable "environment" {
  description = "Ambiente da infraestrutura (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Região Azure onde os recursos serão criados"
  type        = string
  default     = "East US"
}

variable "admin_ip" {
  description = "IP público autorizado para acessar o API Server do AKS (ex: 1.2.3.4/32)"
  type        = string
}

variable "node_count" {
  description = "Número de nós do AKS"
  type        = number
  default     = 2
}