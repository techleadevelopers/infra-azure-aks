import logging
import uuid

from fastapi import FastAPI, HTTPException, status
from fastapi.responses import JSONResponse
from pydantic import BaseModel, constr
from celery import Celery

from .config import get_settings

settings = get_settings()

logger = logging.getLogger("api")
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s %(message)s",
)

celery_app = Celery(
    "async_ai_api",
    broker=settings.broker_url,
    backend=settings.result_backend,
)
celery_app.conf.task_default_queue = settings.default_queue


class AnalyzeRequest(BaseModel):
    content: constr(min_length=1, max_length=8000)


class AnalyzeResponse(BaseModel):
    job_id: str
    status: str = "accepted"


class StatusResponse(BaseModel):
    job_id: str
    status: str
    result: dict | None = None
    error: str | None = None


app = FastAPI(title=settings.app_name, version="0.1.0")


@app.get("/health")
def health() -> dict:
    return {"status": "ok"}


@app.post(
    "/v1/analyze",
    response_model=AnalyzeResponse,
    status_code=status.HTTP_202_ACCEPTED,
)
def analyze(payload: AnalyzeRequest):
    job_id = str(uuid.uuid4())
    logger.info(
        "queueing_task",
        extra={
            "job_id": job_id,
            "queue": settings.default_queue,
        },
    )
    celery_app.send_task(
        "tasks.process_payload",
        args=[payload.model_dump(), job_id],
        queue=settings.default_queue,
        routing_key=settings.default_queue,
    )
    return AnalyzeResponse(job_id=job_id)


@app.get("/v1/status/{job_id}", response_model=StatusResponse)
def get_status(job_id: str):
    async_result = celery_app.AsyncResult(job_id)
    resp = StatusResponse(job_id=job_id, status=async_result.status.lower())

    if async_result.successful():
        resp.result = async_result.result
    elif async_result.failed():
        resp.error = str(async_result.result)

    return JSONResponse(status_code=200, content=resp.model_dump())
