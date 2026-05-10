from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from decimal import Decimal


class ListingCreate(BaseModel):
    title: str
    description: Optional[str] = None
    price: Decimal
    category: str
    condition: str


class ListingUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    price: Optional[Decimal] = None
    category: Optional[str] = None
    condition: Optional[str] = None
    status: Optional[str] = None


class ListingResponse(BaseModel):
    id: str
    seller_id: str
    title: str
    description: Optional[str] = None
    price: Decimal
    category: str
    condition: str
    status: str
    image_url: Optional[str] = None
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}

    @classmethod
    def from_orm_listing(cls, obj) -> "ListingResponse":
        return cls(
            id=obj.id,
            seller_id=obj.seller_id,
            title=obj.title,
            description=obj.description,
            price=obj.price,
            category=obj.category,
            condition=obj.item_condition,
            status=obj.status,
            image_url=obj.image_url,
            created_at=obj.created_at,
            updated_at=obj.updated_at,
        )
