# deploy.ps1
$RESOURCE_GROUP = "rg-swappy-prod"
$AKS_NAME      = "aks-swappy-prod"

Write-Host "🔐 Autenticando na Azure..." -ForegroundColor Cyan
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME --overwrite-existing

Write-Host "📦 Atualizando dependências do Helm (RabbitMQ)..." -ForegroundColor Cyan
helm dependency update ./deploy/charts/async-ai

Write-Host "🚀 Iniciando Deploy do Async-AI..." -ForegroundColor Green
helm upgrade --install async-ai ./deploy/charts/async-ai `
  --namespace async-ai --create-namespace `
  --wait --timeout 5m

Write-Host "✅ Sistema online! Verifique os pods com: kubectl get pods -n async-ai" -ForegroundColor Green
