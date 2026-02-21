# Azure Kubernetes Service (AKS) - IaC Strategy 🚀

Este repositório contém a arquitetura de referência para um cluster gerenciado na Azure (AKS), utilizando **Terraform** para garantir uma infraestrutura resiliente, escalável e segura. 

O foco deste setup é suportar ecossistemas de **Microsserviços** e integração com modelos de **IA/LLM**, conforme as melhores práticas de mercado.

## 🏗️ Arquitetura Proposta
- **Resource Group**: Isolamento lógico de todos os recursos.
- **VNet & Subnets**: Segmentação de rede para isolar os nós do AKS da internet pública.
- **AKS Cluster**: Configurado com Identidade Gerenciada (SystemAssigned) e RBAC.
- **Node Pools**: Provisionamento otimizado para cargas de trabalho de alta performance.

## 🛠️ Tecnologias Utilizadas
- **Terraform**: Infraestrutura como Código (IaC).
- **Azure Provider (azurerm)**: Gerenciamento nativo de recursos Microsoft.
- **Kubernetes**: Orquestração de contêineres para Python/TypeScript.

## 🚀 Como utilizar
1. Autentique na Azure: `az login`
2. Inicialize o Terraform: `terraform init`
3. Valide o plano de execução: `terraform plan`
4. Aplique a infraestrutura: `terraform apply`

---
*Este projeto faz parte do meu portfólio de Especialista em Infraestrutura e Arquitetura de Software.*