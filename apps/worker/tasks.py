import logging
import os
import random
import time
from typing import Any

import openai
from celery import states
from celery.exceptions import Ignore

from .celery_app import celery_app

logger = logging.getLogger("worker")
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s %(message)s",
)

openai.api_key = os.getenv("OPENAI_API_KEY")


@celery_app.task(
    bind=True,
    name="tasks.process_payload",
    autoretry_for=(openai.RateLimitError, openai.APIConnectionError, Exception),
    retry_backoff=True,
    retry_backoff_max=64,
    retry_jitter=True,
    retry_kwargs={"max_retries": 5},
)
def process_payload(self, payload: dict[str, Any], job_id: str):
    try:
        logger.info(
            "task_started",
            extra={"job_id": job_id, "content_length": len(payload.get("content", ""))},
        )

        # Simulação / chamada real ao OpenAI
        result = call_openai(payload["content"])

        logger.info("task_completed", extra={"job_id": job_id})
        return {"job_id": job_id, "result": result}
    except Exception as exc:  # noqa: BLE001
        logger.error("task_failed", extra={"job_id": job_id, "error": str(exc)})
        self.update_state(state=states.FAILURE, meta={"exc": str(exc)})
        raise


def call_openai(text: str) -> dict[str, Any]:
    """
    Substitua esta função por uma chamada real.
    Aqui apenas simulamos latência e resposta.
    """
    # Simula latência da chamada externa
    time.sleep(random.uniform(0.3, 1.2))

    # Se a chave não estiver configurada, retorna mock
    if not openai.api_key:
        return {"summary": f"mocked response for '{text[:50]}'"}

    # Exemplo minimalista de chamada real (embeddings ou chat)
    try:
        completion = openai.chat.completions.create(
            model=os.getenv("OPENAI_MODEL", "gpt-4.1-mini"),
            messages=[{"role": "user", "content": text}],
            max_tokens=64,
        )
        message = completion.choices[0].message.content
        return {"summary": message}
    except Exception:
        # Propaga para o autoretry
        raise
