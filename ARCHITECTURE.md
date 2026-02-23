# Plano de Arquitetura - Async AI em AKS

## Componentes
- **AKS privado** com OIDC + Workload Identity; node pools `system` e `workload`.
- **App Gateway Ingress Controller** expõe apenas a API (HTTP/HTTPS); worker fica interno.
- **RabbitMQ** (Bitnami subchart ou Azure RabbitMQ gerenciado) provê filas `requests` e `results`.
- **API FastAPI**: endpoint síncrono que enfileira; métricas Prometheus via middleware; logs estruturados para Log Analytics (via OTLP).
- **Worker Celery**: consome `requests`, chama OpenAI, publica em `results`; usa `OPENAI_API_KEY` do Key Vault via CSI + Workload Identity.
- **KEDA**: ScaledObject para worker (queueLength >= 50, min 1, max 20, polling 5s, cooldown 60s).
- **CSI Secret Store + Key Vault Provider**: SecretProviderClass monta segredos e sincroniza para Secret Kubernetes.

## Segurança e Rede
- Pods non-root, fsGroup 1000; SA anotada com `azure.workload.identity/client-id`.
- NetworkPolicy (a criar): permitir apenas API/worker -> RabbitMQ; AppGW -> API.
- Private DNS zones para AKS, ACR, Key Vault já definidos no Terraform.

## Observabilidade
- Prometheus scrape na API e worker; opcional RabbitMQ exporter.
- Logs para Log Analytics; traces via OpenTelemetry.
- KEDA/HPA eventos monitorados para capacidade.

## Deploy (resumo)
1) Criar segredos no Key Vault: `openai-api-key`, `rabbitmq-password`, `rabbitmq-connection` (amqp://user:pass@rabbitmq:5672/).
2) Helm: `helm dependency update deploy/charts/async-ai && helm upgrade --install async-ai deploy/charts/async-ai`.
3) Garantir AGIC apontando para o service da API; TLS offload no App Gateway.
