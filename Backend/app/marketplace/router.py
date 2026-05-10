import os
import uuid
import shutil
from decimal import Decimal
from typing import List, Optional

from fastapi import APIRouter, Depends, HTTPException, Query, UploadFile, File, Form, status
from sqlalchemy.orm import Session

from app.database import get_db
from app.auth.dependencies import get_current_user
from app.auth.models import User
from app.marketplace import models, schemas

router = APIRouter(prefix="/listings", tags=["marketplace"])

UPLOAD_DIR = "uploads/listings"


@router.get("/", response_model=List[schemas.ListingResponse])
async def list_listings(
    category: Optional[str] = Query(None),
    search: Optional[str] = Query(None),
    db: Session = Depends(get_db),
):
    """List all active listings, optionally filtered by category or search term."""
    q = db.query(models.Listing).filter(models.Listing.status == "active")
    if category:
        q = q.filter(models.Listing.category == category)
    if search:
        q = q.filter(models.Listing.title.ilike(f"%{search}%"))
    listings = q.order_by(models.Listing.created_at.desc()).all()
    return [schemas.ListingResponse.from_orm_listing(l) for l in listings]


@router.get("/{listing_id}", response_model=schemas.ListingResponse)
async def get_listing(listing_id: str, db: Session = Depends(get_db)):
    """Get a single listing by ID."""
    listing = db.query(models.Listing).filter(models.Listing.id == listing_id).first()
    if not listing:
        raise HTTPException(status_code=404, detail="Publicación no encontrada")
    return schemas.ListingResponse.from_orm_listing(listing)


@router.post("/", response_model=schemas.ListingResponse, status_code=status.HTTP_201_CREATED)
async def create_listing(
    title: str = Form(...),
    description: Optional[str] = Form(None),
    price: Decimal = Form(...),
    category: str = Form(...),
    condition: str = Form(...),
    image: Optional[UploadFile] = File(None),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Create a new marketplace listing."""
    image_url = None
    if image and image.filename:
        ext = os.path.splitext(image.filename)[1]
        filename = f"{uuid.uuid4()}{ext}"
        os.makedirs(UPLOAD_DIR, exist_ok=True)
        with open(f"{UPLOAD_DIR}/{filename}", "wb") as f:
            shutil.copyfileobj(image.file, f)
        image_url = f"/uploads/listings/{filename}"

    listing = models.Listing(
        seller_id=current_user.id,
        title=title,
        description=description,
        price=price,
        category=category,
        item_condition=condition,
        image_url=image_url,
    )
    db.add(listing)
    db.commit()
    db.refresh(listing)
    return schemas.ListingResponse.from_orm_listing(listing)


@router.patch("/{listing_id}", response_model=schemas.ListingResponse)
async def update_listing(
    listing_id: str,
    body: schemas.ListingUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Update a listing (owner only)."""
    listing = db.query(models.Listing).filter(models.Listing.id == listing_id).first()
    if not listing:
        raise HTTPException(status_code=404, detail="Publicación no encontrada")
    if listing.seller_id != current_user.id:
        raise HTTPException(status_code=403, detail="No autorizado")

    data = body.model_dump(exclude_unset=True)
    if "condition" in data:
        listing.item_condition = data.pop("condition")
    for field, value in data.items():
        setattr(listing, field, value)

    db.commit()
    db.refresh(listing)
    return schemas.ListingResponse.from_orm_listing(listing)


@router.delete("/{listing_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_listing(
    listing_id: str,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Delete a listing (owner only)."""
    listing = db.query(models.Listing).filter(models.Listing.id == listing_id).first()
    if not listing:
        raise HTTPException(status_code=404, detail="Publicación no encontrada")
    if listing.seller_id != current_user.id:
        raise HTTPException(status_code=403, detail="No autorizado")
    db.delete(listing)
    db.commit()
