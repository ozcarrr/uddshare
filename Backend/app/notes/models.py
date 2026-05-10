import uuid
from datetime import datetime
from sqlalchemy import Column, String, Text, Integer, DateTime, ForeignKey
from app.database import Base


class Note(Base):
    __tablename__ = "notes"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    uploader_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"))
    title = Column(String(255), nullable=False)
    description = Column(Text)
    career = Column(String(255), nullable=False)
    course = Column(String(255), nullable=False)
    semester = Column(String(50))
    file_url = Column(String(500), nullable=False)
    file_type = Column(String(50))
    download_count = Column(Integer, default=0)
    created_at = Column(DateTime, default=datetime.utcnow)
