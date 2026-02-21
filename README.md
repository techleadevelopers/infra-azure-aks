# Azure AKS Enterprise Platform (Terraform)

Enterprise-grade Kubernetes platform on Azure designed for production workloads, built with Infrastructure as Code and aligned with modern DevOps and Platform Engineering practices.

This project demonstrates the design and implementation of a secure, scalable and observable AKS environment, suitable for microservices, APIs and AI-driven applications.

<div align="center"> <img src="https://res.cloudinary.com/limpeja/image/upload/v1771688064/elllallalal_dkk1vr.png" width="1024"> </div>

## Project Context

This repository represents a real-world platform foundation designed for organizations that require:

- Network isolation
- Zero public exposure of cluster control plane
|- Perimeter protection (WAF)
- Workload segregation
- Centralized observability
- Scalable infrastructure provisioning

The architecture follows secure-by-default and production-first principles.

## Architecture Overview

Core components provisioned via Terraform:

- Resource Group
- Virtual Network with segmented subnets
- Private Azure Kubernetes Service (AKS)
- Dedicated System and Workload Node Pools
- Application Gateway WAF v2 (Layer 7 protection)
- Public IP (Application Gateway only)
- Log Analytics Workspace

## Design Decisions

| Decision              | Reason                                      |
| --------------------- | ------------------------------------------- |
| Private AKS           | Prevent public access to Kubernetes API     |
| Azure CNI             | Enterprise network integration              |
| Node Pool segregation | Isolate system components from workloads    |
| WAF v2                | Protect applications from OWASP Top 10      |
| Managed Identity      | Avoid credential management                 |
| Terraform             | Reproducible environments and governance    |

## Security Architecture

### Cluster

- Private API Server
- No public IPs on nodes
- Managed Identity (SystemAssigned)
- Azure Policy enabled
- RBAC integration

Access requires:

- VPN / ExpressRoute **or**
- A host within the VNet (jumpbox/bastion)

### Network

- Dedicated VNet
- Subnet isolation:
  - AKS
  - Application Gateway
- Azure CNI networking
- No direct internet exposure to cluster nodes

### Perimeter Protection

- Application Gateway configuration:
  - SKU: WAF_v2
  - Mode: Prevention
  - OWASP Rule Set 3.2
  - TLS modern policy
- Protection against:
  - SQL Injection
  - XSS
  - Layer 7 attacks

## Kubernetes Configuration

### System Node Pool

Handles:

- Core Kubernetes components
- Critical cluster services

Config:

- Auto-scaling enabled
- Min: 1 / Max: 3

### Workload Node Pool

Designed for application workloads:

- Mode: User
- Label: workload=apps
- Independent auto-scaling
- Min: 1 / Max: 5

Enables workload isolation and scaling independence.

## Observability

- Azure Monitor integration
- Log Analytics Workspace
- Container and system logs
- Metrics collection
- Operational diagnostics
- 30-day retention

## Infrastructure as Code

Technologies:

- Terraform >= 1.5
- AzureRM Provider
- Azure CLI

Deployment workflow:

Escrita

```
az login
terraform init
terraform plan
terraform apply
```

Destroy environment:

Escrita

```
terraform destroy
```

## Cost Awareness

Always-on cost components:

- AKS node VMs
- Application Gateway WAF v2
- Public IP
- Log ingestion

For development/testing environments:

- Reduce node pool limits
- Use smaller VM sizes
- Destroy resources when not in use

## DevOps & Platform Engineering Practices Demonstrated

- Infrastructure as Code
- Immutable infrastructure approach
- Environment parameterization
- Secure-by-default architecture
- Production-oriented network design
- Separation of concerns (system vs workload)
- Observability from day one
- Cost awareness and lifecycle management

## Potential Enhancements (Roadmap)

- Private DNS Zone
- Azure Bastion
- GitOps (ArgoCD / Flux)
- Workload Identity
- Azure Key Vault CSI Driver
- Horizontal Pod Autoscaler
- Network Policies
- Azure Defender for Containers
- CI/CD pipeline for Terraform

## Use Cases

- Enterprise microservices platforms
- Internal developer platforms (IDP)
- API platforms
- AI/ML services
- Financial or regulated environments

## Author Perspective

This project reflects my approach to DevOps and Platform Engineering:

- Security and network isolation as a foundation
- Infrastructure designed for production from day one
- Automation and reproducibility over manual configuration
- Focus on operational visibility and scalability
