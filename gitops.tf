variable "enable_gitops_argocd" {
  description = "Enable ArgoCD GitOps installation via Helm (requires network access to the private AKS API)"
  type        = bool
  default     = false
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks.kube_config[0].host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
  }
}

resource "helm_release" "argocd" {
  count            = var.enable_gitops_argocd ? 1 : 0
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.46.8"

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "redis-ha.enabled"
    value = "true"
  }

  depends_on = [azurerm_kubernetes_cluster.aks]
}
