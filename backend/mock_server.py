"""
MPS 생태계 - Mock 백엔드 API 서버
FastAPI를 사용한 간단한 Mock 서버 구현
"""

from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from datetime import datetime, timedelta
from typing import List, Optional
import json

app = FastAPI(title="MPS Mock API", version="1.0.0")

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ============ Models ============

class AuthToken(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    expires_in: int = 3600

class User(BaseModel):
    id: str
    email: str
    name: str
    created_at: str

class LoginRequest(BaseModel):
    email: str
    password: str

class SignupRequest(BaseModel):
    email: str
    password: str
    name: str

class MeasurementResult(BaseModel):
    id: str
    user_id: str
    type: str
    value: float
    unit: str
    timestamp: str

class HealthScore(BaseModel):
    score: int
    status: str
    risk_factors: List[str]

# ============ In-Memory Database ============

users_db = {
    "user@example.com": {
        "id": "user1",
        "email": "user@example.com",
        "password": "password123",
        "name": "테스트 사용자",
        "created_at": datetime.now().isoformat(),
    }
}

measurements_db = {
    "user1": [
        {
            "id": "measure1",
            "user_id": "user1",
            "type": "health",
            "value": 85,
            "unit": "score",
            "timestamp": (datetime.now() - timedelta(hours=2)).isoformat(),
        },
        {
            "id": "measure2",
            "user_id": "user1",
            "type": "environment",
            "value": 22,
            "unit": "celsius",
            "timestamp": (datetime.now() - timedelta(hours=1)).isoformat(),
        },
    ]
}

tokens_db = {}

# ============ Auth Endpoints ============

@app.post("/auth/login", response_model=AuthToken)
async def login(request: LoginRequest):
    """사용자 로그인"""
    user = users_db.get(request.email)
    if not user or user["password"] != request.password:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    access_token = f"access_{user['id']}"
    refresh_token = f"refresh_{user['id']}"
    tokens_db[access_token] = {
        "user_id": user["id"],
        "expires": (datetime.now() + timedelta(hours=1)).isoformat(),
    }
    
    return AuthToken(
        access_token=access_token,
        refresh_token=refresh_token,
        expires_in=3600,
    )

@app.post("/auth/signup", response_model=AuthToken)
async def signup(request: SignupRequest):
    """회원가입"""
    if request.email in users_db:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    user_id = f"user_{len(users_db)}"
    users_db[request.email] = {
        "id": user_id,
        "email": request.email,
        "password": request.password,
        "name": request.name,
        "created_at": datetime.now().isoformat(),
    }
    
    access_token = f"access_{user_id}"
    refresh_token = f"refresh_{user_id}"
    tokens_db[access_token] = {
        "user_id": user_id,
        "expires": (datetime.now() + timedelta(hours=1)).isoformat(),
    }
    
    return AuthToken(
        access_token=access_token,
        refresh_token=refresh_token,
        expires_in=3600,
    )

@app.post("/auth/refresh-token", response_model=AuthToken)
async def refresh_token(refresh_token: str):
    """토큰 갱신"""
    if not refresh_token.startswith("refresh_"):
        raise HTTPException(status_code=401, detail="Invalid token")
    
    user_id = refresh_token.replace("refresh_", "")
    access_token = f"access_{user_id}"
    tokens_db[access_token] = {
        "user_id": user_id,
        "expires": (datetime.now() + timedelta(hours=1)).isoformat(),
    }
    
    return AuthToken(
        access_token=access_token,
        refresh_token=refresh_token,
        expires_in=3600,
    )

@app.get("/auth/me", response_model=User)
async def get_me(authorization: str = None):
    """현재 사용자 정보"""
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    access_token = authorization.replace("Bearer ", "")
    if access_token not in tokens_db:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    user_id = tokens_db[access_token]["user_id"]
    for user in users_db.values():
        if user["id"] == user_id:
            return User(
                id=user["id"],
                email=user["email"],
                name=user["name"],
                created_at=user["created_at"],
            )
    
    raise HTTPException(status_code=404, detail="User not found")

@app.post("/auth/logout")
async def logout(authorization: str = None):
    """로그아웃"""
    if not authorization:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    access_token = authorization.replace("Bearer ", "")
    if access_token in tokens_db:
        del tokens_db[access_token]
    
    return {"status": "logged out"}

# ============ Home Endpoints ============

@app.get("/home/health-score")
async def get_health_score(authorization: str = None):
    """건강 점수 조회"""
    if not authorization:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    return HealthScore(
        score=85,
        status="normal",
        risk_factors=[],
    )

@app.get("/home/recent-measurements")
async def get_recent_measurements(authorization: str = None):
    """최근 측정 조회"""
    if not authorization:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    return {
        "measurements": [
            {
                "id": "m1",
                "name": "건강 측정",
                "date": datetime.now().isoformat(),
                "result": "정상",
            },
            {
                "id": "m2",
                "name": "환경 측정",
                "date": (datetime.now() - timedelta(hours=1)).isoformat(),
                "result": "양호",
            },
        ]
    }

@app.get("/home/environment")
async def get_environment_data(authorization: str = None):
    """환경 데이터 조회"""
    if not authorization:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    return {
        "temperature": 22,
        "humidity": 55,
        "pressure": 1013,
        "timestamp": datetime.now().isoformat(),
    }

@app.get("/home/ai-insight")
async def get_ai_insight(authorization: str = None):
    """AI 인사이트 조회"""
    if not authorization:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    return {
        "message": "건강한 상태입니다. 계속 좋은 습관을 유지하세요.",
        "severity": "info",
        "timestamp": datetime.now().isoformat(),
    }

# ============ Measurement Endpoints ============

@app.post("/measurement/start")
async def start_measurement(measurement_type: str, authorization: str = None):
    """측정 시작"""
    if not authorization:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    return {
        "session_id": f"session_{measurement_type}",
        "status": "started",
        "timestamp": datetime.now().isoformat(),
    }

@app.get("/measurement/result/{session_id}")
async def get_measurement_result(session_id: str, authorization: str = None):
    """측정 결과 조회"""
    if not authorization:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    return {
        "session_id": session_id,
        "value": 85,
        "unit": "score",
        "status": "completed",
        "timestamp": datetime.now().isoformat(),
    }

@app.get("/measurement/history")
async def get_measurement_history(authorization: str = None):
    """측정 기록 조회"""
    if not authorization:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    return {
        "measurements": [
            {
                "id": f"m{i}",
                "type": ["health", "environment", "water"][i % 3],
                "value": 70 + i,
                "timestamp": (datetime.now() - timedelta(days=i)).isoformat(),
            }
            for i in range(10)
        ]
    }

# ============ Data Hub Endpoints ============

@app.get("/data-hub/trends")
async def get_trends(measurement_type: str, authorization: str = None):
    """추세 데이터 조회"""
    if not authorization:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    return {
        "type": measurement_type,
        "data": [
            {"date": (datetime.now() - timedelta(days=i)).isoformat(), "value": 70 + i}
            for i in range(30)
        ],
    }

@app.post("/data-hub/export")
async def export_data(format: str, authorization: str = None):
    """데이터 내보내기"""
    if not authorization:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    return {
        "format": format,
        "url": f"/downloads/data_{datetime.now().timestamp()}.{format.lower()}",
        "expires_in": 3600,
    }

# ============ AI Coach Endpoints ============

@app.post("/coaching/chat")
async def chat(message: str, authorization: str = None):
    """AI 채팅"""
    if not authorization:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    # 간단한 Mock 응답
    responses = {
        "건강": "건강 관리에 대해 알려드리겠습니다.",
        "운동": "하루에 30분의 운동을 권장합니다.",
        "수면": "충분한 수면이 건강의 기초입니다.",
    }
    
    response = responses.get("건강", "무엇을 도와드릴까요?")
    for key in responses:
        if key in message:
            response = responses[key]
            break
    
    return {
        "response": response,
        "timestamp": datetime.now().isoformat(),
    }

# ============ Marketplace Endpoints ============

@app.get("/marketplace/cartridges")
async def get_cartridges(category: Optional[str] = None, authorization: str = None):
    """카트리지 목록 조회"""
    if not authorization:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    cartridges = [
        {
            "id": f"cart{i}",
            "name": f"카트리지 #{i}",
            "category": ["health", "environment", "water"][i % 3],
            "price": 99000 + i * 1000,
            "description": "고품질 카트리지",
        }
        for i in range(10)
    ]
    
    if category:
        cartridges = [c for c in cartridges if c["category"] == category]
    
    return {"cartridges": cartridges}

@app.post("/marketplace/cart/add")
async def add_to_cart(cartridge_id: str, authorization: str = None):
    """장바구니에 추가"""
    if not authorization:
        raise HTTPException(status_code=401, detail="Unauthorized")
    
    return {"status": "added", "cartridge_id": cartridge_id}

# ============ Health Check ============

@app.get("/health")
async def health_check():
    """헬스 체크"""
    return {"status": "ok", "timestamp": datetime.now().isoformat()}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
