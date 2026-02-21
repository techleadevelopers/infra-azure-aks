# =========================
# Resource Group
# =========================
output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Nome do Resource Group criado."
}

# =========================
# AKS Cluster Name
# =========================
output "kubernetes_cluster_name" {
  value       = azurerm_kubernetes_cluster.aks.name
  description = "Nome do cluster Kubernetes."
}

# =========================
# Comando para configurar kubectl
# =========================
output "configure_kubectl" {
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.aks.name}"
  description = "Execute este comando para conectar o kubectl ao cluster."
}

# =========================
# Log Analytics Workspace ID
# =========================
output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.logs.workspace_id
  description = "Workspace ID para integração com Grafana / Prometheus."
}

# =========================
# Application Gateway Public IP
# =========================
output "appgw_public_ip" {
  value       = azurerm_public_ip.appgw_pip.ip_address
  description = "IP público do Application Gateway (WAF)."
}