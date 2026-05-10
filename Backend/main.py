import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from app.database import engine, Base
from app.auth.router import auth_router, users_router
from app.marketplace.router import router as marketplace_router
from app.notes.router import router as notes_router

# Create DB tables on startup
Base.metadata.create_all(bind=engine)

# Create upload directories
os.makedirs("uploads/listings", exist_ok=True)
os.makedirs("uploads/notes", exist_ok=True)

app = FastAPI(title="UDDShare API", version="1.0.0", description="Plataforma estudiantil UDD")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")

app.include_router(auth_router, prefix="/api/v1")
app.include_router(users_router, prefix="/api/v1")
app.include_router(marketplace_router, prefix="/api/v1")
app.include_router(notes_router, prefix="/api/v1")


@app.get("/health", tags=["health"])
async def health():
    """Health check."""
    return {"status": "ok"}
