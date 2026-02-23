# Stage 1: Builder
FROM ghcr.io/astral-sh/uv:python3.12-slim AS builder
ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy
WORKDIR /app
COPY pyproject.toml uv.lock ./
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-install-project --no-dev

# Stage 2: Runtime
FROM python:3.12-slim
WORKDIR /app
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1
    
# Criar usuário não-root
RUN groupadd -r celery && useradd -r -g celery celery
COPY --from=builder --chown=celery:celery /app/.venv /app/.venv
COPY --chown=celery:celery . .

USER celery
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD celery -A tasks inspect ping
    
ENTRYPOINT ["celery", "-A", "tasks", "worker", "--loglevel=info"]
