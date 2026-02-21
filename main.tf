# 1. Configuração do Terraform e Providers
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 2. Grupo de Recursos
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location
}

# 3. Rede Virtual (VNet) e Subnet
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.project_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "snet-aks"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 4. Azure Kubernetes Service (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.project_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = var.project_name

  default_node_pool {
    name                = "default"
    node_count          = 2
    vm_size             = "Standard_DC2s_v3" # VM disponível na sua cota
    vnet_subnet_id      = azurerm_subnet.aks_subnet.id
    enable_auto_scaling = true
    max_count           = 5
    min_count           = 1
  }

  identity {
    type = "SystemAssigned"
  }

  # RESOLVE O ERRO DE OVERLAP (Conflito de IP)
  network_profile {
    network_plugin     = "azure"
    service_cidr       = "172.16.0.0/16" # IPs dos serviços (fora da VNet 10.0)
    dns_service_ip     = "172.16.0.10"   # IP do DNS interno
    docker_bridge_cidr = "172.17.0.1/16"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 5. Log Analytics (Observabilidade)
resource "azurerm_log_analytics_workspace" "insights" {
  name                = "logs-${var.project_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}