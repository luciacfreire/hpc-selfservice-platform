from fastapi import APIRouter
import httpx
import os

router = APIRouter(prefix="/workflows", tags=["workflows"])

ARGO_SERVER = os.getenv("ARGO_SERVER", "http://localhost:2746")
ARGO_TOKEN = os.getenv("ARGO_TOKEN")

@router.get("/")
async def list_workflows():
    async with httpx.AsyncClient(verify=False) as client:
        headers = {"Authorization": ARGO_TOKEN}
        response = await client.get(
            f"{ARGO_SERVER}/api/v1/workflows/argo",
            headers=headers
        )
        return response.json()

@router.post("/submit")
async def submit_workflow(workflow: dict):
    async with httpx.AsyncClient(verify=False) as client:
        headers = {"Authorization": ARGO_TOKEN}
        response = await client.post(
            f"{ARGO_SERVER}/api/v1/workflows/argo",
            headers=headers,
            json=workflow
        )
        return response.json()

@router.get("/{name}")
async def get_workflow(name: str):
    async with httpx.AsyncClient(verify=False) as client:
        headers = {"Authorization": ARGO_TOKEN}
        response = await client.get(
            f"{ARGO_SERVER}/api/v1/workflows/argo/{name}",
            headers=headers
        )
        return response.json()

@router.delete("/{name}")
async def delete_workflow(name: str):
    async with httpx.AsyncClient(verify=False) as client:
        headers = {"Authorization": ARGO_TOKEN}
        response = await client.delete(
            f"{ARGO_SERVER}/api/v1/workflows/argo/{name}",
            headers=headers
        )
        return response.json()

@router.get("/{name}/log")
async def get_workflow_logs(name: str):
    async with httpx.AsyncClient(verify=False) as client:
        headers = {"Authorization": ARGO_TOKEN}
        response = await client.get(
            f"{ARGO_SERVER}/api/v1/workflows/argo/{name}/log",
            headers=headers
        )
        return response.json()