from fastapi import FastAPI, HTTPException, Depends, Header
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine, Column, String, Text, DateTime, Boolean, JSON
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
import jwt
from datetime import datetime, timedelta
from typing import Optional, List, Dict
import os
import json
import logging

# ============================================
# Configuration
# ============================================
app = FastAPI(title="Translation Service", version="1.0.0")

logger = logging.getLogger(__name__)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:password@db:5432/mps_translation"
)
engine = create_engine(DATABASE_URL, echo=False)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# JWT
JWT_SECRET = os.getenv("JWT_SECRET", "your-secret-key")
JWT_ALGORITHM = "HS256"

# Supported languages
SUPPORTED_LANGUAGES = {
    "ko": "Korean",
    "en": "English",
    "ja": "Japanese",
    "zh": "Chinese",
    "es": "Spanish",
    "fr": "French",
    "de": "German",
    "it": "Italian",
    "ru": "Russian",
    "pt": "Portuguese",
}

# ============================================
# Database Models
# ============================================

class Translation(Base):
    __tablename__ = "translations"
    
    id = Column(String, primary_key=True)
    user_id = Column(String, index=True)
    source_language = Column(String)
    target_language = Column(String)
    source_text = Column(Text)
    translated_text = Column(Text)
    context = Column(String)
    is_approved = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class TranslationTemplate(Base):
    __tablename__ = "translation_templates"
    
    id = Column(String, primary_key=True)
    template_key = Column(String, unique=True, index=True)
    translations = Column(JSON)  # {"ko": "...", "en": "...", ...}
    category = Column(String)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.utcnow)


class LanguagePreference(Base):
    __tablename__ = "language_preferences"
    
    id = Column(String, primary_key=True)
    user_id = Column(String, unique=True, index=True)
    preferred_language = Column(String)
    secondary_language = Column(String)
    auto_translate = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class GlossaryEntry(Base):
    __tablename__ = "glossary_entries"
    
    id = Column(String, primary_key=True)
    term = Column(String, index=True)
    language = Column(String)
    definition = Column(Text)
    category = Column(String)  # medical, technical, etc.
    created_at = Column(DateTime, default=datetime.utcnow)


# ============================================
# Database Initialization
# ============================================

Base.metadata.create_all(bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# ============================================
# Authentication
# ============================================

def verify_token(authorization: Optional[str] = Header(None)) -> Dict:
    if not authorization:
        raise HTTPException(status_code=401, detail="Token not provided")
    
    try:
        token = authorization.split(" ")[1]
        payload = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        return payload
    except Exception as err:
        raise HTTPException(status_code=403, detail="Invalid token")


# ============================================
# Health Check
# ============================================

@app.get("/health")
async def health_check():
    return {
        "status": "ok",
        "service": "translation-service",
        "timestamp": datetime.utcnow().isoformat(),
    }


# ============================================
# Translation Endpoints
# ============================================

@app.post("/api/v1/translate")
async def translate_text(
    request: Dict,
    user: Dict = Depends(verify_token),
    db: Session = Depends(get_db),
):
    """
    Translate text from source language to target language
    """
    try:
        source_language = request.get("source_language", "ko")
        target_language = request.get("target_language", "en")
        text = request.get("text")
        context = request.get("context")  # optional context for better translation

        if not text:
            raise HTTPException(status_code=400, detail="Text is required")

        # Simple translation logic (in production, use Google Translate API, etc.)
        translated_text = await perform_translation(
            text, source_language, target_language, context
        )

        # Save to database
        import uuid
        translation_id = str(uuid.uuid4())
        translation = Translation(
            id=translation_id,
            user_id=user.get("id"),
            source_language=source_language,
            target_language=target_language,
            source_text=text,
            translated_text=translated_text,
            context=context,
        )
        db.add(translation)
        db.commit()
        db.refresh(translation)

        return {
            "success": True,
            "data": {
                "id": translation.id,
                "source_language": translation.source_language,
                "target_language": translation.target_language,
                "source_text": translation.source_text,
                "translated_text": translation.translated_text,
                "context": translation.context,
            },
        }

    except Exception as err:
        logger.error(f"Error translating text: {err}")
        raise HTTPException(status_code=500, detail="Translation failed")


@app.get("/api/v1/translations")
async def get_translations(
    user: Dict = Depends(verify_token),
    db: Session = Depends(get_db),
    limit: int = 50,
    offset: int = 0,
):
    """
    Get user's translation history
    """
    try:
        translations = db.query(Translation).filter(
            Translation.user_id == user.get("id")
        ).order_by(Translation.created_at.desc()).limit(limit).offset(offset).all()

        return {
            "success": True,
            "data": [
                {
                    "id": t.id,
                    "source_language": t.source_language,
                    "target_language": t.target_language,
                    "source_text": t.source_text,
                    "translated_text": t.translated_text,
                    "created_at": t.created_at.isoformat(),
                }
                for t in translations
            ],
            "count": len(translations),
        }

    except Exception as err:
        logger.error(f"Error fetching translations: {err}")
        raise HTTPException(status_code=500, detail="Failed to fetch translations")


# ============================================
# Template Translations
# ============================================

@app.get("/api/v1/templates/{template_key}")
async def get_template_translation(
    template_key: str,
    language: str = "ko",
    db: Session = Depends(get_db),
):
    """
    Get translated template by key and language
    """
    try:
        template = db.query(TranslationTemplate).filter(
            TranslationTemplate.template_key == template_key,
            TranslationTemplate.is_active == True,
        ).first()

        if not template:
            raise HTTPException(status_code=404, detail="Template not found")

        translations = template.translations or {}
        translated_text = translations.get(language, translations.get("ko", ""))

        return {
            "success": True,
            "data": {
                "key": template.template_key,
                "language": language,
                "text": translated_text,
                "category": template.category,
            },
        }

    except Exception as err:
        logger.error(f"Error fetching template: {err}")
        raise HTTPException(status_code=500, detail="Failed to fetch template")


@app.post("/api/v1/templates")
async def create_template(
    request: Dict,
    user: Dict = Depends(verify_token),
    db: Session = Depends(get_db),
):
    """
    Create new translation template (admin only)
    """
    try:
        import uuid
        template_id = str(uuid.uuid4())
        template = TranslationTemplate(
            id=template_id,
            template_key=request.get("template_key"),
            translations=request.get("translations", {}),
            category=request.get("category"),
        )
        db.add(template)
        db.commit()
        db.refresh(template)

        return {
            "success": True,
            "message": "Template created successfully",
            "data": {
                "id": template.id,
                "key": template.template_key,
                "category": template.category,
            },
        }

    except Exception as err:
        logger.error(f"Error creating template: {err}")
        raise HTTPException(status_code=500, detail="Failed to create template")


# ============================================
# Language Preferences
# ============================================

@app.get("/api/v1/language-preferences")
async def get_language_preferences(
    user: Dict = Depends(verify_token),
    db: Session = Depends(get_db),
):
    """
    Get user's language preferences
    """
    try:
        prefs = db.query(LanguagePreference).filter(
            LanguagePreference.user_id == user.get("id")
        ).first()

        if not prefs:
            # Return default preferences
            return {
                "success": True,
                "data": {
                    "preferred_language": "ko",
                    "secondary_language": "en",
                    "auto_translate": False,
                },
            }

        return {
            "success": True,
            "data": {
                "preferred_language": prefs.preferred_language,
                "secondary_language": prefs.secondary_language,
                "auto_translate": prefs.auto_translate,
            },
        }

    except Exception as err:
        logger.error(f"Error fetching language preferences: {err}")
        raise HTTPException(status_code=500, detail="Failed to fetch preferences")


@app.put("/api/v1/language-preferences")
async def update_language_preferences(
    request: Dict,
    user: Dict = Depends(verify_token),
    db: Session = Depends(get_db),
):
    """
    Update user's language preferences
    """
    try:
        import uuid
        user_id = user.get("id")
        
        prefs = db.query(LanguagePreference).filter(
            LanguagePreference.user_id == user_id
        ).first()

        if not prefs:
            prefs = LanguagePreference(
                id=str(uuid.uuid4()),
                user_id=user_id,
                preferred_language=request.get("preferred_language", "ko"),
                secondary_language=request.get("secondary_language", "en"),
                auto_translate=request.get("auto_translate", False),
            )
            db.add(prefs)
        else:
            prefs.preferred_language = request.get("preferred_language", prefs.preferred_language)
            prefs.secondary_language = request.get("secondary_language", prefs.secondary_language)
            prefs.auto_translate = request.get("auto_translate", prefs.auto_translate)
            prefs.updated_at = datetime.utcnow()

        db.commit()
        db.refresh(prefs)

        return {
            "success": True,
            "message": "Preferences updated successfully",
            "data": {
                "preferred_language": prefs.preferred_language,
                "secondary_language": prefs.secondary_language,
                "auto_translate": prefs.auto_translate,
            },
        }

    except Exception as err:
        logger.error(f"Error updating preferences: {err}")
        raise HTTPException(status_code=500, detail="Failed to update preferences")


# ============================================
# Glossary
# ============================================

@app.get("/api/v1/glossary/{term}")
async def get_glossary_entry(
    term: str,
    language: str = "ko",
    db: Session = Depends(get_db),
):
    """
    Get glossary entry by term
    """
    try:
        entry = db.query(GlossaryEntry).filter(
            GlossaryEntry.term.ilike(f"%{term}%"),
            GlossaryEntry.language == language,
        ).first()

        if not entry:
            return {
                "success": True,
                "data": None,
                "message": "No glossary entry found",
            }

        return {
            "success": True,
            "data": {
                "term": entry.term,
                "definition": entry.definition,
                "language": entry.language,
                "category": entry.category,
            },
        }

    except Exception as err:
        logger.error(f"Error fetching glossary entry: {err}")
        raise HTTPException(status_code=500, detail="Failed to fetch glossary entry")


@app.post("/api/v1/glossary")
async def add_glossary_entry(
    request: Dict,
    user: Dict = Depends(verify_token),
    db: Session = Depends(get_db),
):
    """
    Add new glossary entry
    """
    try:
        import uuid
        entry = GlossaryEntry(
            id=str(uuid.uuid4()),
            term=request.get("term"),
            language=request.get("language", "ko"),
            definition=request.get("definition"),
            category=request.get("category"),
        )
        db.add(entry)
        db.commit()
        db.refresh(entry)

        return {
            "success": True,
            "message": "Glossary entry added successfully",
            "data": {
                "id": entry.id,
                "term": entry.term,
            },
        }

    except Exception as err:
        logger.error(f"Error adding glossary entry: {err}")
        raise HTTPException(status_code=500, detail="Failed to add glossary entry")


# ============================================
# Helper Functions
# ============================================

async def perform_translation(
    text: str, source_language: str, target_language: str, context: Optional[str] = None
) -> str:
    """
    Perform actual translation
    In production, integrate with Google Translate, Microsoft Translator, etc.
    """
    try:
        # Simple placeholder - in production use actual translation API
        if source_language == target_language:
            return text
        
        # Mock translation (replace with real API call)
        translation_map = {
            ("ko", "en"): f"[EN] {text}",
            ("en", "ko"): f"[KO] {text}",
            ("ko", "ja"): f"[JA] {text}",
            ("ko", "zh"): f"[ZH] {text}",
        }
        
        return translation_map.get((source_language, target_language), text)
    
    except Exception as err:
        logger.error(f"Translation error: {err}")
        raise


if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PORT", 3007))
    uvicorn.run(app, host="0.0.0.0", port=port)
