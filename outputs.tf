# 1. Nome do Grupo de Recursos (Útil para comandos az cli)
output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Nome do Resource Group criado."
}

# 2. Nome do Cluster AKS
output "kubernetes_cluster_name" {
  value       = azurerm_kubernetes_cluster.aks.name
  description = "Nome do cluster Kubernetes."
}

# 3. Comando para configurar o kubectl (O "Pulo do Gato")
output "configure_kubectl" {
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.aks.name}"
  description = "Execute este comando para conectar o kubectl ao seu novo cluster."
}

# 4. ID do Log Analytics (Para configurar Grafana/Prometheus)
output "log_analytics_workspace_id" {
  value       = azurerm_log_analytics_workspace.insights.workspace_id
  description = "ID do Workspace para integração de observabilidade."
}