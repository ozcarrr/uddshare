from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.auth import models, schemas
from app.auth.utils import hash_password, verify_password, create_access_token
from app.auth.dependencies import get_current_user

auth_router = APIRouter(prefix="/auth", tags=["auth"])
users_router = APIRouter(prefix="/users", tags=["users"])


@auth_router.post("/register", response_model=schemas.Token, status_code=status.HTTP_201_CREATED)
async def register(body: schemas.UserCreate, db: Session = Depends(get_db)):
    """Register a new UDD student account."""
    if not body.email.endswith("@udd.cl"):
        raise HTTPException(status_code=400, detail="Solo se permiten correos @udd.cl")

    if db.query(models.User).filter(models.User.email == body.email).first():
        raise HTTPException(status_code=400, detail="El correo ya está registrado")

    user = models.User(
        email=body.email,
        hashed_password=hash_password(body.password),
        display_name=body.display_name,
        career=body.career,
    )
    db.add(user)
    db.commit()
    db.refresh(user)

    token = create_access_token({"sub": user.id, "email": user.email})
    return schemas.Token(access_token=token, user=schemas.UserResponse.model_validate(user))


@auth_router.post("/login", response_model=schemas.Token)
async def login(body: schemas.UserLogin, db: Session = Depends(get_db)):
    """Authenticate with email and password."""
    user = db.query(models.User).filter(models.User.email == body.email).first()
    if not user or not verify_password(body.password, user.hashed_password):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Credenciales inválidas")

    token = create_access_token({"sub": user.id, "email": user.email})
    return schemas.Token(access_token=token, user=schemas.UserResponse.model_validate(user))


@users_router.get("/me", response_model=schemas.UserResponse)
async def get_me(current_user: models.User = Depends(get_current_user)):
    """Get the current user's profile."""
    return current_user


@users_router.patch("/me", response_model=schemas.UserResponse)
async def update_me(
    body: schemas.UserUpdate,
    current_user: models.User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Update display name or career."""
    if body.display_name is not None:
        current_user.display_name = body.display_name
    if body.career is not None:
        current_user.career = body.career
    db.commit()
    db.refresh(current_user)
    return current_user
