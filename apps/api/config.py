import os
from pydantic import BaseModel, AnyUrl, Field, ValidationError


class Settings(BaseModel):
    app_name: str = "async-ai-api"
    environment: str = os.getenv("ENVIRONMENT", "prod")
    rabbitmq_host: str = os.getenv("RABBITMQ_HOST", "rabbitmq")
    rabbitmq_user: str = os.getenv("RABBITMQ_USER", "user")
    rabbitmq_password: str = os.getenv("RABBITMQ_PASSWORD", "password")
    rabbitmq_vhost: str = os.getenv("RABBITMQ_VHOST", "/")
    rabbitmq_port: int = int(os.getenv("RABBITMQ_PORT", "5672"))
    result_backend: str = os.getenv("RESULT_BACKEND", "rpc://")
    default_queue: str = os.getenv("QUEUE_NAME", "requests")
    result_queue: str = os.getenv("RESULT_QUEUE", "results")

    @property
    def broker_url(self) -> str:
        return (
            f"amqp://{self.rabbitmq_user}:"
            f"{self.rabbitmq_password}@{self.rabbitmq_host}:"
            f"{self.rabbitmq_port}/{self.rabbitmq_vhost.lstrip('/')}"
        )


def get_settings() -> Settings:
    try:
        return Settings()
    except ValidationError as exc:
        raise RuntimeError(f"Invalid configuration: {exc}") from exc
