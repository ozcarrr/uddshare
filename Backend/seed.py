import uuid
from app.database import SessionLocal, engine, Base
from app.auth.models import User
from app.auth.utils import hash_password
from app.marketplace.models import Listing
from app.notes.models import Note

Base.metadata.create_all(bind=engine)

db = SessionLocal()

try:
    user1 = User(
        id=str(uuid.uuid4()),
        email="ana.gomez@udd.cl",
        hashed_password=hash_password("password123"),
        display_name="Ana Gómez",
        career="Ingeniería Civil",
    )
    user2 = User(
        id=str(uuid.uuid4()),
        email="pedro.silva@udd.cl",
        hashed_password=hash_password("password123"),
        display_name="Pedro Silva",
        career="Diseño",
    )
    db.add_all([user1, user2])
    db.flush()

    listing1 = Listing(
        id=str(uuid.uuid4()),
        seller_id=user1.id,
        title="Cálculo Diferencial - Stewart 8va Ed.",
        description="Libro en buen estado, sin subrayados. Ideal para primer año de ingeniería.",
        price=12000,
        category="libros",
        item_condition="usado",
        status="active",
    )
    listing2 = Listing(
        id=str(uuid.uuid4()),
        seller_id=user2.id,
        title="Calculadora Casio fx-991LA Plus",
        description="Calculadora científica casi sin uso, con estuche original.",
        price=25000,
        category="electronica",
        item_condition="como_nuevo",
        status="active",
    )
    db.add_all([listing1, listing2])

    note1 = Note(
        id=str(uuid.uuid4()),
        uploader_id=user1.id,
        title="Resumen Cálculo I - Límites y Derivadas",
        description="Apuntes completos del primer semestre con ejemplos resueltos.",
        career="Ingeniería Civil",
        course="Cálculo I",
        semester="2025-1",
        file_url="/uploads/notes/resumen_calculo1.pdf",
        file_type="pdf",
        download_count=0,
    )
    note2 = Note(
        id=str(uuid.uuid4()),
        uploader_id=user2.id,
        title="Guía de Tipografía y Color",
        description="Material de apoyo para Diseño Visual, incluye paletas y ejemplos.",
        career="Diseño",
        course="Diseño Visual",
        semester="2025-1",
        file_url="/uploads/notes/guia_tipografia.pdf",
        file_type="pdf",
        download_count=0,
    )
    db.add_all([note1, note2])

    db.commit()
    print("Seed data inserted successfully.")
    print(f"  Users:    ana.gomez@udd.cl / pedro.silva@udd.cl  (password: password123)")
    print(f"  Listings: {listing1.title} | {listing2.title}")
    print(f"  Notes:    {note1.title} | {note2.title}")
except Exception as e:
    db.rollback()
    print(f"Error: {e}")
finally:
    db.close()
