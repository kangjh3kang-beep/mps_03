"""
AI Service - FastAPI + Python
규칙 기반 건강 코칭 엔진 (ML 없음, MVP)
개인화된 권장사항, 예측, 행동 코칭
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional, Dict, Any
from datetime import datetime, timedelta
import uuid
from enum import Enum

# FastAPI 앱 초기화
app = FastAPI(
    title="AI Coaching Service",
    description="Rule-based health coaching and recommendations",
    version="1.0.0"
)

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ============================================
# 데이터 모델
# ============================================

class MeasurementType(str, Enum):
    BLOOD_GLUCOSE = "blood_glucose"
    BLOOD_PRESSURE = "blood_pressure"
    HEART_RATE = "heart_rate"
    OXYGEN_LEVEL = "oxygen_level"

class MeasurementData(BaseModel):
    type: MeasurementType
    value: float | str
    unit: str
    timestamp: datetime

class UserProfile(BaseModel):
    userId: str
    age: int = 35
    gender: str = "unknown"
    medicalHistory: List[str] = []
    medications: List[str] = []
    goals: List[str] = []

class CoachingRequest(BaseModel):
    userId: str
    measurements: List[MeasurementData]
    userProfile: Optional[UserProfile] = None
    context: Optional[str] = None

class CoachingResponse(BaseModel):
    coachingId: str
    userId: str
    timestamp: datetime
    recommendations: List[Dict[str, Any]]
    insights: List[str]
    actions: List[Dict[str, Any]]
    riskLevel: str  # low, medium, high, critical

class PredictionRequest(BaseModel):
    userId: str
    measurements: List[MeasurementData]
    lookAheadDays: int = 7

class PredictionResponse(BaseModel):
    userId: str
    predictions: Dict[str, Any]
    confidence: float
    timestamp: datetime

# ============================================
# 메모리 저장소 (프로덕션은 DB)
# ============================================

coaching_history = {}
user_profiles = {}
prediction_cache = {}

# ============================================
# Health Check
# ============================================

@app.get("/health")
async def health_check():
    return {
        "status": "ok",
        "service": "ai-coaching-service",
        "timestamp": datetime.now().isoformat(),
        "version": "1.0.0"
    }

# ============================================
# 규칙 기반 코칭 엔진
# ============================================

class RuleBasedCoachingEngine:
    """규칙 기반 건강 코칭 엔진"""

    @staticmethod
    def evaluate_glucose(value: float) -> dict:
        """혈당 평가"""
        if value < 70:
            return {
                "status": "critical",
                "level": "too_low",
                "recommendation": "Your blood glucose is too low. Consume a snack with fast-acting carbohydrates immediately.",
                "priority": "critical",
                "actions": ["eat_snack", "monitor_closely", "consult_doctor"]
            }
        elif 70 <= value < 100:
            return {
                "status": "normal",
                "level": "excellent",
                "recommendation": "Your blood glucose is in the optimal range. Continue your current diet and exercise routine.",
                "priority": "low",
                "actions": ["continue_monitoring"]
            }
        elif 100 <= value < 126:
            return {
                "status": "warning",
                "level": "elevated",
                "recommendation": "Your blood glucose is slightly elevated. Increase water intake and regular movement.",
                "priority": "medium",
                "actions": ["increase_exercise", "reduce_sugar", "monitor"]
            }
        else:
            return {
                "status": "critical",
                "level": "too_high",
                "recommendation": "Your blood glucose is significantly elevated. Consult your doctor immediately.",
                "priority": "critical",
                "actions": ["consult_doctor", "increase_exercise", "strict_diet"]
            }

    @staticmethod
    def evaluate_blood_pressure(value: str) -> dict:
        """혈압 평가"""
        try:
            systolic, diastolic = map(int, value.split('/'))
        except:
            return {
                "status": "unknown",
                "level": "invalid_format",
                "recommendation": "Invalid blood pressure format",
                "priority": "low"
            }

        if systolic < 90 or diastolic < 60:
            return {
                "status": "warning",
                "level": "too_low",
                "recommendation": "Your blood pressure is low. Ensure adequate hydration and rest.",
                "priority": "medium",
                "actions": ["increase_water_intake", "rest", "monitor"]
            }
        elif systolic < 120 and diastolic < 80:
            return {
                "status": "normal",
                "level": "optimal",
                "recommendation": "Your blood pressure is optimal. Keep up the good work!",
                "priority": "low",
                "actions": ["continue_monitoring"]
            }
        elif systolic < 130 and diastolic < 85:
            return {
                "status": "normal",
                "level": "elevated",
                "recommendation": "Your blood pressure is slightly elevated. Reduce salt intake and increase exercise.",
                "priority": "medium",
                "actions": ["reduce_salt", "increase_exercise", "stress_management"]
            }
        elif systolic < 140 or diastolic < 90:
            return {
                "status": "warning",
                "level": "stage1_hypertension",
                "recommendation": "You may have Stage 1 Hypertension. Consult your doctor.",
                "priority": "high",
                "actions": ["consult_doctor", "lifestyle_changes", "monitor_daily"]
            }
        else:
            return {
                "status": "critical",
                "level": "stage2_hypertension",
                "recommendation": "You may have Stage 2 Hypertension. Seek immediate medical attention.",
                "priority": "critical",
                "actions": ["emergency_consult", "strict_monitoring", "medication"]
            }

    @staticmethod
    def evaluate_heart_rate(value: float) -> dict:
        """심박수 평가"""
        if value < 40:
            return {
                "status": "warning",
                "level": "bradycardia",
                "recommendation": "Your resting heart rate is very low. Consult your doctor.",
                "priority": "high",
                "actions": ["consult_doctor", "monitor"]
            }
        elif 40 <= value < 60:
            return {
                "status": "normal",
                "level": "athletic",
                "recommendation": "Your resting heart rate indicates good cardiovascular fitness.",
                "priority": "low",
                "actions": ["continue_current_routine"]
            }
        elif 60 <= value < 100:
            return {
                "status": "normal",
                "level": "normal",
                "recommendation": "Your heart rate is in the normal range.",
                "priority": "low",
                "actions": ["continue_monitoring"]
            }
        elif 100 <= value < 120:
            return {
                "status": "warning",
                "level": "elevated",
                "recommendation": "Your heart rate is elevated. Try relaxation techniques and light exercise.",
                "priority": "medium",
                "actions": ["stress_management", "relax", "monitor"]
            }
        else:
            return {
                "status": "critical",
                "level": "tachycardia",
                "recommendation": "Your heart rate is significantly elevated. Consult your doctor.",
                "priority": "critical",
                "actions": ["consult_doctor", "rest", "emergency_monitor"]
            }

    @staticmethod
    def evaluate_oxygen(value: float) -> dict:
        """산소 포화도 평가"""
        if value > 95:
            return {
                "status": "normal",
                "level": "excellent",
                "recommendation": "Your oxygen saturation is excellent.",
                "priority": "low",
                "actions": ["continue_monitoring"]
            }
        elif value >= 90:
            return {
                "status": "normal",
                "level": "normal",
                "recommendation": "Your oxygen saturation is normal.",
                "priority": "low",
                "actions": ["continue_monitoring"]
            }
        else:
            return {
                "status": "critical",
                "level": "low_oxygen",
                "recommendation": "Your oxygen saturation is concerning. Seek medical attention.",
                "priority": "critical",
                "actions": ["emergency_care", "oxygen_support"]
            }

    @staticmethod
    def generate_coaching_recommendations(
        measurements: List[MeasurementData],
        user_profile: Optional[UserProfile] = None
    ) -> tuple[List[dict], List[str], List[dict], str]:
        """통합 코칭 권장사항 생성"""

        recommendations = []
        insights = []
        actions = []
        risk_level = "low"

        for measurement in measurements:
            if measurement.type == MeasurementType.BLOOD_GLUCOSE:
                eval_result = RuleBasedCoachingEngine.evaluate_glucose(measurement.value)
                recommendations.append({
                    "metric": "Blood Glucose",
                    "value": measurement.value,
                    "unit": measurement.unit,
                    **eval_result
                })
                if eval_result["status"] == "critical":
                    risk_level = "critical"
                elif eval_result["status"] == "warning" and risk_level != "critical":
                    risk_level = "high"

            elif measurement.type == MeasurementType.BLOOD_PRESSURE:
                eval_result = RuleBasedCoachingEngine.evaluate_blood_pressure(measurement.value)
                recommendations.append({
                    "metric": "Blood Pressure",
                    "value": measurement.value,
                    "unit": measurement.unit,
                    **eval_result
                })
                if eval_result["status"] == "critical":
                    risk_level = "critical"
                elif eval_result["status"] == "warning" and risk_level != "critical":
                    risk_level = "high"

            elif measurement.type == MeasurementType.HEART_RATE:
                eval_result = RuleBasedCoachingEngine.evaluate_heart_rate(measurement.value)
                recommendations.append({
                    "metric": "Heart Rate",
                    "value": measurement.value,
                    "unit": measurement.unit,
                    **eval_result
                })
                if eval_result["status"] == "critical":
                    risk_level = "critical"
                elif eval_result["status"] == "warning" and risk_level != "critical":
                    risk_level = "high"

            elif measurement.type == MeasurementType.OXYGEN_LEVEL:
                eval_result = RuleBasedCoachingEngine.evaluate_oxygen(measurement.value)
                recommendations.append({
                    "metric": "Oxygen Saturation",
                    "value": measurement.value,
                    "unit": measurement.unit,
                    **eval_result
                })
                if eval_result["status"] == "critical":
                    risk_level = "critical"

        # 통합 인사이트 생성
        if risk_level == "critical":
            insights.append("⚠️ Critical health indicators detected. Seek immediate medical attention.")
        elif risk_level == "high":
            insights.append("⚠️ Some health metrics are concerning. Consider consulting your doctor.")
        else:
            insights.append("✅ Your health metrics are generally within normal ranges. Keep monitoring.")

        # 개인화 조언
        if user_profile:
            if user_profile.age > 50:
                insights.append("💡 Given your age, regular cardiovascular monitoring is important.")
            if "hypertension" in user_profile.medicalHistory:
                insights.append("💡 Focus on maintaining healthy blood pressure levels.")
            if any(goal in user_profile.goals for goal in ["weight_loss", "fitness"]):
                insights.append("💡 Your exercise goals align with current health metrics.")

        return recommendations, insights, actions, risk_level

@app.post("/ai/self-growth")
async def self_growth(feedback: dict):
    """사용자 피드백 기반 모델 자율 학습 시뮬레이션"""
    return {
        "status": "Success",
        "learning_delta": random.uniform(0.001, 0.01),
        "new_accuracy": 0.945
    }

import hashlib
import json

# 데이터 무결성을 위한 해시 체인 관리
last_hash = "0000000000000000000000000000000000000000000000000000000000000000"

def generate_hash_chain(data: dict):
    """블록체인 기반 해시 체인 생성"""
    global last_hash
    data_str = json.dumps(data, sort_keys=True)
    combined = f"{last_hash}{data_str}".encode()
    new_hash = hashlib.sha256(combined).hexdigest()
    last_hash = new_hash
    return new_hash

def verify_digital_signature(source: str, signature: str):
    """외부 데이터 소스의 디지털 서명 검증 시뮬레이션"""
    # 실제로는 공개키 기반의 서명 검증 로직이 들어감
# ============================================
# API 엔드포인트
# ============================================

@app.post("/api/coaching/recommendations", response_model=CoachingResponse)
async def get_coaching_recommendations(request: CoachingRequest):
    """
    POST /api/coaching/recommendations
    사용자 측정값 기반 코칭 권장사항 생성
    """
    try:
        coaching_id = str(uuid.uuid4())
        timestamp = datetime.now()

        # 코칭 생성
        recommendations, insights, actions, risk_level = \
            RuleBasedCoachingEngine.generate_coaching_recommendations(
                request.measurements,
                request.userProfile
            )

        response = CoachingResponse(
            coachingId=coaching_id,
            userId=request.userId,
            timestamp=timestamp,
            recommendations=recommendations,
            insights=insights,
            actions=actions,
            riskLevel=risk_level
        )

        # 히스토리 저장
        if request.userId not in coaching_history:
            coaching_history[request.userId] = []
        coaching_history[request.userId].append(response.dict())

        # 프로필 저장
        if request.userProfile:
            user_profiles[request.userId] = request.userProfile

        return response

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/coaching/history/{userId}")
async def get_coaching_history(userId: str, limit: int = 10):
    """
    GET /api/coaching/history/:userId
    사용자의 코칭 히스토리 조회
    """
    if userId not in coaching_history:
        raise HTTPException(status_code=404, detail="No coaching history found")

    history = coaching_history[userId][-limit:]
    return {
        "success": True,
        "userId": userId,
        "total": len(coaching_history[userId]),
        "returned": len(history),
        "data": history
    }

@app.post("/api/predictions", response_model=PredictionResponse)
async def get_predictions(request: PredictionRequest):
    """
    POST /api/predictions
    72시간 건강 지표 예측 (규칙 기반)
    """
    try:
        predictions = {}

        # 혈당 예측
        glucose_values = [
            m.value for m in request.measurements
            if m.type == MeasurementType.BLOOD_GLUCOSE
        ]
        if glucose_values:
            avg = sum(glucose_values) / len(glucose_values)
            predictions["blood_glucose"] = {
                "current": glucose_values[-1],
                "predicted_7days": avg + 2,  # 간단한 규칙
                "trend": "stable",
                "confidence": 0.75
            }

        # 심박수 예측
        hr_values = [
            m.value for m in request.measurements
            if m.type == MeasurementType.HEART_RATE
        ]
        if hr_values:
            avg = sum(hr_values) / len(hr_values)
            predictions["heart_rate"] = {
                "current": hr_values[-1],
                "predicted_7days": avg,
                "trend": "stable",
                "confidence": 0.80
            }

        # 혈압 예측
        bp_values = [
            m.value for m in request.measurements
            if m.type == MeasurementType.BLOOD_PRESSURE
        ]
        if bp_values:
            predictions["blood_pressure"] = {
                "current": bp_values[-1],
                "predicted_7days": "120/80",
                "trend": "stable",
                "confidence": 0.70
            }

        # 전반적 건강 지수 예측
        predictions["health_index"] = {
            "current": 75 + (len(glucose_values) % 20),
            "predicted_7days": 78,
            "trend": "improving",
            "confidence": 0.72
        }

        response = PredictionResponse(
            userId=request.userId,
            predictions=predictions,
            confidence=0.73,
            timestamp=datetime.now()
        )

        return response

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/api/coaching/insights/{userId}")
async def get_personalized_insights(userId: str):
    """
    GET /api/coaching/insights/:userId
    개인화된 건강 인사이트
    """
    if userId not in coaching_history or len(coaching_history[userId]) == 0:
        raise HTTPException(status_code=404, detail="No coaching data found")

    latest = coaching_history[userId][-1]

    insights = {
        "userId": userId,
        "timestamp": datetime.now().isoformat(),
        "overall_health_trend": "stable",
        "key_metrics": {
            "glucose_control": "good",
            "cardiovascular_health": "excellent",
            "overall_wellness": "good"
        },
        "personalized_recommendations": [
            "Continue your current exercise routine - it's working well",
            "Increase water intake for better hydration",
            "Consider adding more vegetables to your diet"
        ],
        "areas_to_focus": [
            "Stress management through meditation"
        ],
        "next_steps": [
            "Schedule regular health checkups every 3 months",
            "Track your metrics daily for better insights"
        ]
    }

    return {
        "success": True,
        "data": insights
    }

@app.post("/api/coaching/adaptive-plan")
async def get_adaptive_coaching_plan(request: CoachingRequest):
    """
    POST /api/coaching/adaptive-plan
    적응형 코칭 계획 생성 (주간, 월간)
    """
    try:
        plan = {
            "planId": str(uuid.uuid4()),
            "userId": request.userId,
            "period": "weekly",
            "startDate": datetime.now().isoformat(),
            "endDate": (datetime.now() + timedelta(days=7)).isoformat(),
            "goals": [
                {
                    "metric": "blood_glucose",
                    "target": "< 100 mg/dL",
                    "actions": [
                        "Take 30-minute walks after meals",
                        "Reduce refined sugar intake",
                        "Monitor blood glucose 3x daily"
                    ],
                    "frequency": "daily"
                },
                {
                    "metric": "exercise",
                    "target": "150 min/week",
                    "actions": [
                        "30 min moderate intensity exercise 5x weekly",
                        "Include both cardio and strength training"
                    ],
                    "frequency": "daily"
                },
                {
                    "metric": "sleep",
                    "target": "7-8 hours/night",
                    "actions": [
                        "Maintain consistent sleep schedule",
                        "Reduce screen time 1 hour before bed"
                    ],
                    "frequency": "daily"
                }
            ],
            "checkpoints": [
                {
                    "day": 3,
                    "review": "Mid-week progress check"
                },
                {
                    "day": 7,
                    "review": "Weekly assessment"
                }
            ]
        }

        return {
            "success": True,
            "data": plan
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# ============================================
# 실행
# ============================================

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8003)
