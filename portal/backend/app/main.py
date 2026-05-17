from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app import workflows
from dotenv import load_dotenv
load_dotenv()

app = FastAPI(
    title="HPC Self-Service Portal API",
    description="API REST para la gestión de trabajos HPC sobre Kubernetes",
    version="1.0.0"
)

# Permitir peticiones desde el frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(workflows.router)

@app.get("/")
def root():
    return {"message": "HPC Self-Service Portal API", "status": "running"}

