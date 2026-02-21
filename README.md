# Azure AKS Enterprise Platform – Infrastructure as Code

Este repositório contém a definição de infraestrutura para provisionamento de uma plataforma Azure Kubernetes Service (AKS) utilizando Terraform. A solução foi projetada para ambientes corporativos que exigem segurança de rede, governança, observabilidade e escalabilidade, sendo adequada para workloads de microsserviços, APIs críticas e aplicações de alta disponibilidade.

## Objetivo
Provisionar uma base padronizada e reproduzível para execução de workloads em Kubernetes com:
- Segurança por padrão (secure-by-default)
- Isolamento de rede
- Controle de acesso ao plano de gerenciamento
- Monitoramento centralizado
- Proteção de perímetro (WAF)

## Arquitetura de Alto Nível
Recursos provisionados:
- Resource Group dedicado
- Virtual Network (VNet)
- Subnet para AKS
- Subnet dedicada para Application Gateway
- AKS Private Cluster
- Node Pools segregados (System / Workload)
- Application Gateway WAF v2
- Public IP Standard (App Gateway)
- Log Analytics Workspace

## Segurança
**Cluster**
- Private AKS Cluster
- Endpoint da API acessível apenas por IP autorizado (/32)
- Azure RBAC habilitado
- Managed Identity (SystemAssigned)
- Azure Policy habilitado

**Rede**
- Segmentação via VNet e Subnets
- Nós do cluster sem exposição pública
- Tráfego externo controlado via Application Gateway

**Perímetro**
- Application Gateway configurado com:
  - SKU: WAF_v2
  - Firewall Mode: Prevention
  - OWASP Rule Set 3.2
  - Proteção contra: SQL Injection, XSS, ataques de camada 7

## Kubernetes – Configuração
**System Node Pool**
- Responsável por componentes do Kubernetes e serviços críticos do cluster

**Workload Node Pool**
- Auto Scaling habilitado
- Escala independente
- Label: `workload=apps`
- Tamanho de VM: `Standard_DC2s_v3`

## Observabilidade
- Log Analytics Workspace
- Monitoramento do cluster via OMS Agent
- Retenção padrão: 30 dias
- Permite: logs de sistema, métricas de cluster e diagnóstico operacional

## Estrutura de Variáveis
```hcl
variable "project_name" {
  default = "ap-design-ai"
}

variable "environment" {
  default = "prod"
}

variable "location" {
  default = "East US"
}

variable "admin_ip" {
  description = "IP autorizado para acesso ao API Server (CIDR)"
}
```

Exemplo de valor:
```hcl
admin_ip = "187.xxx.xxx.xxx/32"
```

## Pré-requisitos
- Azure CLI
- Terraform >= 1.5
- Permissões para criação de recursos na subscription

Login:
```bash
az login
```

## Deploy
Inicialização:
```bash
terraform init
```

Validação:
```bash
terraform plan
```

Provisionamento:
```bash
terraform apply
```

## Configuração do kubectl
Após o deploy:
```bash
az aks get-credentials \
  --resource-group rg-ap-design-ai-prod \
  --name aks-ap-design-ai-prod
```

## Gestão de Custos
Recursos que geram custo contínuo:
- AKS (nós)
- Application Gateway WAF v2
- Public IP Standard
- Log Analytics

Para ambientes de teste:
```bash
terraform destroy
```

Nota: parar o cluster não remove custos do Application Gateway ou IP público.

## Boas Práticas Implementadas
- Infrastructure as Code
- Ambientes isolados por variáveis
- Segurança por padrão
- Separação de workloads
- Controle de acesso ao plano de gerenciamento
- Proteção de perímetro
- Monitoramento centralizado

## Possíveis Extensões
- Private DNS Zone
- Azure Bastion
- GitOps (ArgoCD / Flux)
- Managed Identity para workloads
- Horizontal Pod Autoscaler
- Azure Key Vault Integration
- Network Policies

## Uso Corporativo
Este repositório destina-se a:
- Times de Plataforma / DevOps
- Padronização de ambientes Kubernetes
- Ambientes de produção ou staging corporativos
- Base para plataformas internas de microsserviços
