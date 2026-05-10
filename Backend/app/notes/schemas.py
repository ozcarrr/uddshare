from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class NoteResponse(BaseModel):
    id: str
    uploader_id: str
    title: str
    description: Optional[str] = None
    career: str
    course: str
    semester: Optional[str] = None
    file_url: str
    file_type: Optional[str] = None
    download_count: int
    created_at: datetime

    model_config = {"from_attributes": True}
