import os
from celery import Celery


def _broker_url() -> str:
    host = os.getenv("RABBITMQ_HOST", "rabbitmq")
    user = os.getenv("RABBITMQ_USER", "user")
    password = os.getenv("RABBITMQ_PASSWORD", "password")
    vhost = os.getenv("RABBITMQ_VHOST", "/")
    port = os.getenv("RABBITMQ_PORT", "5672")
    return f"amqp://{user}:{password}@{host}:{port}/{vhost.lstrip('/')}"


celery_app = Celery(
    "async_ai_worker",
    broker=_broker_url(),
    backend=os.getenv("RESULT_BACKEND", "rpc://"),
)

celery_app.conf.task_default_queue = os.getenv("QUEUE_NAME", "requests")
celery_app.conf.task_acks_late = True
celery_app.conf.worker_prefetch_multiplier = 1
