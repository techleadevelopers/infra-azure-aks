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

# 2. Grupo de Recursos (Container lógico)
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location
}

# 3. Rede Virtual (VNet) - Onde a mágica acontece
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.project_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Subnet específica para o AKS
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
    name           = "default"
    node_count     = var.node_count
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
    
    # Habilita o auto-scaling dos nós (Papo de Sênior)
    enable_auto_scaling = true
    max_count           = 5
    min_count           = 1
  }

  # Identidade Gerenciada (Segurança: sem senhas hardcoded)
  identity {
    type = "SystemAssigned"
  }

  # Integração com Azure Monitor / Log Analytics (Observabilidade)
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# 5. Log Analytics (Para o Grafana/Prometheus da vaga lerem depois)
resource "azurerm_log_analytics_workspace" "insights" {
  name                = "logs-${var.project_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}