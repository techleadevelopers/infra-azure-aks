# Deleta o Storage do Terraform (CUIDADO: Você perderá o histórico do Terraform)
az group delete --name rg-terraform-state --yes --no-wait

# Deleta o monitor de rede
az group delete --name NetworkWatcherRG --yes --no-wait# Deleta o Storage do Terraform (CUIDADO: Você perderá o histórico do Terraform)
az group delete --name rg-terraform-state --yes --no-wait

# Deleta o monitor de rede
az group delete --name NetworkWatcherRG --yes --no-wait