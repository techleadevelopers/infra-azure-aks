# syntax=docker/dockerfile:1
FROM python:3.12-slim AS builder
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1
RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential gcc \
 && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY pyproject.toml poetry.lock* requirements*.txt* ./
RUN python -m venv /venv \
 && /venv/bin/pip install --upgrade pip \
 && if [ -f poetry.lock ]; then /venv/bin/pip install poetry && POETRY_VIRTUALENVS_CREATE=false poetry install --without dev; \
    elif [ -f requirements.txt ]; then /venv/bin/pip install -r requirements.txt; fi
COPY . .
RUN /venv/bin/pip install . || true

FROM python:3.12-slim AS runtime
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    TZ=UTC \
    PATH="/venv/bin:$PATH"
RUN addgroup --system app && adduser --system --ingroup app --home /app app
WORKDIR /app
COPY --from=builder /venv /venv
COPY --from=builder /app /app
USER app
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD uvicorn api.main:app --factory --host 127.0.0.1 --port 9000 --loop uvloop --http httptools --lifespan off --log-level warning --timeout-keep-alive 5 || exit 1
CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000", "--factory"]
