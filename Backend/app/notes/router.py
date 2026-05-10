import os
import uuid
import shutil
from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query, UploadFile, File, Form, status
from sqlalchemy.orm import Session

from app.database import get_db
from app.auth.dependencies import get_current_user
from app.auth.models import User
from app.notes import models, schemas

router = APIRouter(prefix="/notes", tags=["notes"])

UPLOAD_DIR = "uploads/notes"


@router.get("/", response_model=List[schemas.NoteResponse])
async def list_notes(
    career: Optional[str] = Query(None),
    course: Optional[str] = Query(None),
    search: Optional[str] = Query(None),
    db: Session = Depends(get_db),
):
    """List notes with optional filters by career, course, or search term."""
    q = db.query(models.Note)
    if career:
        q = q.filter(models.Note.career == career)
    if course:
        q = q.filter(models.Note.course == course)
    if search:
        q = q.filter(models.Note.title.ilike(f"%{search}%"))
    return q.order_by(models.Note.created_at.desc()).all()


@router.get("/{note_id}", response_model=schemas.NoteResponse)
async def get_note(note_id: str, db: Session = Depends(get_db)):
    """Get note metadata by ID."""
    note = db.query(models.Note).filter(models.Note.id == note_id).first()
    if not note:
        raise HTTPException(status_code=404, detail="Apunte no encontrado")
    return note


@router.post("/", response_model=schemas.NoteResponse, status_code=status.HTTP_201_CREATED)
async def upload_note(
    title: str = Form(...),
    description: Optional[str] = Form(None),
    career: str = Form(...),
    course: str = Form(...),
    semester: Optional[str] = Form(None),
    file: UploadFile = File(...),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Upload a note file and metadata."""
    ext = os.path.splitext(file.filename)[1].lower().lstrip(".")
    filename = f"{uuid.uuid4()}.{ext}"
    os.makedirs(UPLOAD_DIR, exist_ok=True)
    with open(f"{UPLOAD_DIR}/{filename}", "wb") as f:
        shutil.copyfileobj(file.file, f)

    note = models.Note(
        uploader_id=current_user.id,
        title=title,
        description=description,
        career=career,
        course=course,
        semester=semester,
        file_url=f"/uploads/notes/{filename}",
        file_type=ext or None,
    )
    db.add(note)
    db.commit()
    db.refresh(note)
    return note


@router.delete("/{note_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_note(
    note_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Delete a note (owner only)."""
    note = db.query(models.Note).filter(models.Note.id == note_id).first()
    if not note:
        raise HTTPException(status_code=404, detail="Apunte no encontrado")
    if note.uploader_id != current_user.id:
        raise HTTPException(status_code=403, detail="No autorizado")
    db.delete(note)
    db.commit()


@router.post("/{note_id}/download")
async def download_note(note_id: str, db: Session = Depends(get_db)):
    """Increment the download count and return the file URL."""
    note = db.query(models.Note).filter(models.Note.id == note_id).first()
    if not note:
        raise HTTPException(status_code=404, detail="Apunte no encontrado")
    note.download_count += 1
    db.commit()
    return {"file_url": note.file_url, "download_count": note.download_count}
