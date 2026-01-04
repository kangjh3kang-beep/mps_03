"""
개인화된 AI 건강 코치
사용자 맞춤형 건강 관리 및 코칭 시스템
"""

import numpy as np
from typing import List, Dict, Optional, Any
from dataclasses import dataclass, field
from enum import Enum
from datetime import datetime, timedelta
import logging

logger = logging.getLogger(__name__)


class GoalType(Enum):
    """건강 목표 유형"""
    GLUCOSE_CONTROL = "glucose_control"
    BLOOD_PRESSURE_MANAGEMENT = "blood_pressure_management"
    WEIGHT_LOSS = "weight_loss"
    WEIGHT_GAIN = "weight_gain"
    FITNESS_IMPROVEMENT = "fitness_improvement"
    STRESS_REDUCTION = "stress_reduction"
    SLEEP_IMPROVEMENT = "sleep_improvement"
    GENERAL_WELLNESS = "general_wellness"


class CoachingStyle(Enum):
    """코칭 스타일"""
    MOTIVATIONAL = "motivational"  # 동기부여형
    ANALYTICAL = "analytical"  # 분석형
    SUPPORTIVE = "supportive"  # 지지형
    DIRECTIVE = "directive"  # 지시형
    ADAPTIVE = "adaptive"  # 적응형 (상황에 따라 변화)


@dataclass
class UserProfile:
    """사용자 프로필"""
    user_id: str
    age: int
    gender: str
    height: float  # cm
    weight: float  # kg
    medical_conditions: List[str] = field(default_factory=list)
    medications: List[str] = field(default_factory=list)
    goals: List[GoalType] = field(default_factory=list)
    preferred_coaching_style: CoachingStyle = CoachingStyle.ADAPTIVE
    activity_level: str = "moderate"  # sedentary, light, moderate, active, very_active
    dietary_restrictions: List[str] = field(default_factory=list)
    
    @property
    def bmi(self) -> float:
        """BMI 계산"""
        height_m = self.height / 100
        return self.weight / (height_m ** 2)
    
    @property
    def bmi_category(self) -> str:
        """BMI 분류"""
        bmi = self.bmi
        if bmi < 18.5:
            return "underweight"
        elif bmi < 23:  # 아시아 기준
            return "normal"
        elif bmi < 25:
            return "overweight"
        else:
            return "obese"


@dataclass
class CoachingMessage:
    """코칭 메시지"""
    type: str  # "tip", "reminder", "alert", "encouragement", "insight"
    title: str
    content: str
    priority: int  # 1-5, 5가 가장 높음
    action_items: List[str] = field(default_factory=list)
    related_goals: List[GoalType] = field(default_factory=list)
    timestamp: str = field(default_factory=lambda: datetime.now().isoformat())


@dataclass
class DailyPlan:
    """일일 건강 계획"""
    date: str
    meals: List[Dict[str, Any]]
    exercises: List[Dict[str, Any]]
    medications: List[Dict[str, Any]]
    measurements: List[Dict[str, Any]]
    hydration_goal: float  # 리터
    sleep_goal: float  # 시간
    custom_activities: List[Dict[str, Any]] = field(default_factory=list)


class PersonalizedCoach:
    """
    개인화된 AI 건강 코치
    사용자 데이터를 기반으로 맞춤형 코칭 제공
    """
    
    def __init__(self):
        self.coaching_templates = self._load_coaching_templates()
        self.meal_database = self._load_meal_database()
        self.exercise_database = self._load_exercise_database()
    
    def create_user_profile(self, user_data: Dict[str, Any]) -> UserProfile:
        """사용자 프로필 생성"""
        goals = [GoalType(g) for g in user_data.get("goals", ["general_wellness"])]
        style = CoachingStyle(user_data.get("coaching_style", "adaptive"))
        
        return UserProfile(
            user_id=user_data["user_id"],
            age=user_data.get("age", 30),
            gender=user_data.get("gender", "unknown"),
            height=user_data.get("height", 170),
            weight=user_data.get("weight", 70),
            medical_conditions=user_data.get("medical_conditions", []),
            medications=user_data.get("medications", []),
            goals=goals,
            preferred_coaching_style=style,
            activity_level=user_data.get("activity_level", "moderate"),
            dietary_restrictions=user_data.get("dietary_restrictions", []),
        )
    
    def generate_coaching_messages(
        self,
        profile: UserProfile,
        measurements: Dict[str, List[float]],
        context: Optional[Dict[str, Any]] = None,
    ) -> List[CoachingMessage]:
        """
        코칭 메시지 생성
        
        Args:
            profile: 사용자 프로필
            measurements: 최근 측정 데이터
            context: 추가 컨텍스트 (시간, 날씨 등)
            
        Returns:
            코칭 메시지 목록
        """
        messages = []
        
        # 혈당 관련 메시지
        if "glucose" in measurements and GoalType.GLUCOSE_CONTROL in profile.goals:
            glucose_messages = self._generate_glucose_coaching(
                profile, measurements["glucose"]
            )
            messages.extend(glucose_messages)
        
        # 혈압 관련 메시지
        if "blood_pressure" in measurements:
            bp_messages = self._generate_bp_coaching(
                profile, measurements["blood_pressure"]
            )
            messages.extend(bp_messages)
        
        # 활동량 관련 메시지
        if "steps" in measurements:
            activity_messages = self._generate_activity_coaching(
                profile, measurements["steps"]
            )
            messages.extend(activity_messages)
        
        # 시간대별 맞춤 메시지
        time_based_messages = self._generate_time_based_coaching(profile, context)
        messages.extend(time_based_messages)
        
        # 동기부여 메시지 (스타일에 따라)
        if profile.preferred_coaching_style in [CoachingStyle.MOTIVATIONAL, CoachingStyle.ADAPTIVE]:
            motivation_message = self._generate_motivation_message(profile, measurements)
            if motivation_message:
                messages.append(motivation_message)
        
        # 우선순위 정렬
        messages.sort(key=lambda m: m.priority, reverse=True)
        
        return messages[:10]  # 최대 10개 메시지
    
    def generate_daily_plan(
        self,
        profile: UserProfile,
        date: str,
        preferences: Optional[Dict[str, Any]] = None,
    ) -> DailyPlan:
        """
        일일 건강 계획 생성
        
        Args:
            profile: 사용자 프로필
            date: 계획 날짜 (YYYY-MM-DD)
            preferences: 사용자 선호도
            
        Returns:
            일일 계획
        """
        # 식사 계획
        meals = self._generate_meal_plan(profile)
        
        # 운동 계획
        exercises = self._generate_exercise_plan(profile)
        
        # 약물 복용 계획
        medications = self._generate_medication_schedule(profile)
        
        # 측정 일정
        measurements = self._generate_measurement_schedule(profile)
        
        # 수분 섭취 목표 (체중 기반)
        hydration_goal = profile.weight * 0.033  # 체중 1kg당 33ml
        
        # 수면 목표
        sleep_goal = self._calculate_sleep_goal(profile)
        
        return DailyPlan(
            date=date,
            meals=meals,
            exercises=exercises,
            medications=medications,
            measurements=measurements,
            hydration_goal=hydration_goal,
            sleep_goal=sleep_goal,
        )
    
    def get_adaptive_plan(
        self,
        profile: UserProfile,
        current_measurements: Dict[str, float],
        progress: Dict[str, float],
    ) -> Dict[str, Any]:
        """
        적응형 계획 생성 (진행 상황에 따라 조정)
        
        Args:
            profile: 사용자 프로필
            current_measurements: 현재 측정값
            progress: 목표 대비 진행률
            
        Returns:
            조정된 계획
        """
        adjustments = {
            "intensity_modifier": 1.0,
            "dietary_adjustments": [],
            "focus_areas": [],
            "warnings": [],
        }
        
        # 혈당 조절 목표인 경우
        if GoalType.GLUCOSE_CONTROL in profile.goals:
            glucose = current_measurements.get("glucose", 100)
            if glucose > 140:
                adjustments["dietary_adjustments"].append({
                    "action": "reduce_carbs",
                    "amount": "20%",
                    "reason": "혈당 조절을 위해 탄수화물 섭취를 줄이세요.",
                })
                adjustments["focus_areas"].append("post_meal_exercise")
            elif glucose < 70:
                adjustments["warnings"].append({
                    "type": "hypoglycemia_risk",
                    "message": "저혈당 위험이 있습니다. 간식을 준비해두세요.",
                })
        
        # 체중 관리 목표인 경우
        if GoalType.WEIGHT_LOSS in profile.goals:
            weight_progress = progress.get("weight", 0)
            if weight_progress < 0.5:  # 목표의 50% 미만 진행
                adjustments["intensity_modifier"] = 1.2
                adjustments["focus_areas"].append("increased_cardio")
            elif weight_progress > 1.5:  # 너무 빠른 감량
                adjustments["warnings"].append({
                    "type": "rapid_weight_loss",
                    "message": "체중이 너무 빨리 감소하고 있습니다. 건강한 속도로 조절하세요.",
                })
                adjustments["intensity_modifier"] = 0.8
        
        # 피트니스 향상 목표인 경우
        if GoalType.FITNESS_IMPROVEMENT in profile.goals:
            if "heart_rate_recovery" in current_measurements:
                recovery = current_measurements["heart_rate_recovery"]
                if recovery < 20:  # 회복이 느린 경우
                    adjustments["focus_areas"].append("recovery_training")
                else:
                    adjustments["intensity_modifier"] = 1.1
        
        return adjustments
    
    def _generate_glucose_coaching(
        self,
        profile: UserProfile,
        glucose_history: List[float],
    ) -> List[CoachingMessage]:
        """혈당 관련 코칭 메시지 생성"""
        messages = []
        
        if not glucose_history:
            return messages
        
        recent = glucose_history[-1] if glucose_history else 100
        avg = np.mean(glucose_history[-7:]) if len(glucose_history) >= 7 else recent
        trend = np.mean(np.diff(glucose_history[-5:])) if len(glucose_history) >= 5 else 0
        
        # 현재 상태 기반 메시지
        if recent > 180:
            messages.append(CoachingMessage(
                type="alert",
                title="혈당 주의",
                content=f"현재 혈당이 {recent:.0f}mg/dL로 높습니다. 수분을 충분히 섭취하고 가벼운 운동을 하세요.",
                priority=5,
                action_items=["물 한 잔 마시기", "15분 걷기", "1시간 후 재측정"],
                related_goals=[GoalType.GLUCOSE_CONTROL],
            ))
        elif recent < 70:
            messages.append(CoachingMessage(
                type="alert",
                title="저혈당 주의",
                content=f"현재 혈당이 {recent:.0f}mg/dL로 낮습니다. 빠르게 당분을 섭취하세요.",
                priority=5,
                action_items=["포도당 정제 또는 주스 섭취", "15분 후 재측정", "증상 지속시 의료진 연락"],
                related_goals=[GoalType.GLUCOSE_CONTROL],
            ))
        elif 70 <= recent <= 100:
            messages.append(CoachingMessage(
                type="encouragement",
                title="혈당 관리 잘 되고 있어요!",
                content=f"현재 혈당 {recent:.0f}mg/dL, 정상 범위입니다. 좋은 관리를 유지하세요.",
                priority=2,
                related_goals=[GoalType.GLUCOSE_CONTROL],
            ))
        
        # 추세 기반 메시지
        if trend > 10:
            messages.append(CoachingMessage(
                type="tip",
                title="혈당 상승 추세",
                content="최근 혈당이 상승 추세입니다. 식사량과 탄수화물 섭취를 점검해보세요.",
                priority=3,
                action_items=["식사 일지 검토", "탄수화물 섭취량 확인"],
                related_goals=[GoalType.GLUCOSE_CONTROL],
            ))
        
        return messages
    
    def _generate_bp_coaching(
        self,
        profile: UserProfile,
        bp_history: List[float],
    ) -> List[CoachingMessage]:
        """혈압 관련 코칭 메시지 생성"""
        messages = []
        
        if not bp_history:
            return messages
        
        recent = bp_history[-1] if bp_history else 120
        
        if recent > 140:
            messages.append(CoachingMessage(
                type="alert",
                title="혈압 관리 필요",
                content="혈압이 높습니다. 염분 섭취를 줄이고 규칙적인 운동을 하세요.",
                priority=4,
                action_items=["저염식 실천", "심호흡 5분", "약 복용 확인"],
                related_goals=[GoalType.BLOOD_PRESSURE_MANAGEMENT],
            ))
        elif recent < 90:
            messages.append(CoachingMessage(
                type="tip",
                title="저혈압 주의",
                content="혈압이 낮습니다. 갑자기 일어나지 말고 수분을 충분히 섭취하세요.",
                priority=3,
                action_items=["천천히 기립", "수분 섭취"],
                related_goals=[GoalType.BLOOD_PRESSURE_MANAGEMENT],
            ))
        
        return messages
    
    def _generate_activity_coaching(
        self,
        profile: UserProfile,
        steps_history: List[float],
    ) -> List[CoachingMessage]:
        """활동량 관련 코칭 메시지 생성"""
        messages = []
        
        if not steps_history:
            return messages
        
        today_steps = steps_history[-1] if steps_history else 0
        avg_steps = np.mean(steps_history[-7:]) if len(steps_history) >= 7 else today_steps
        
        goal_steps = 10000
        if profile.activity_level == "sedentary":
            goal_steps = 5000
        elif profile.activity_level == "light":
            goal_steps = 7500
        elif profile.activity_level in ["active", "very_active"]:
            goal_steps = 12000
        
        if today_steps >= goal_steps:
            messages.append(CoachingMessage(
                type="encouragement",
                title="목표 달성! 🎉",
                content=f"오늘 {int(today_steps):,}걸음으로 목표를 달성했습니다!",
                priority=2,
                related_goals=[GoalType.FITNESS_IMPROVEMENT],
            ))
        elif today_steps < goal_steps * 0.5:
            messages.append(CoachingMessage(
                type="reminder",
                title="움직임이 필요해요",
                content=f"현재 {int(today_steps):,}걸음입니다. 가벼운 산책 어떠세요?",
                priority=3,
                action_items=["10분 산책하기", "계단 이용하기"],
                related_goals=[GoalType.FITNESS_IMPROVEMENT],
            ))
        
        return messages
    
    def _generate_time_based_coaching(
        self,
        profile: UserProfile,
        context: Optional[Dict[str, Any]] = None,
    ) -> List[CoachingMessage]:
        """시간대별 맞춤 코칭 메시지"""
        messages = []
        
        now = datetime.now()
        hour = now.hour
        
        # 아침 (6-9시)
        if 6 <= hour < 9:
            if GoalType.GLUCOSE_CONTROL in profile.goals:
                messages.append(CoachingMessage(
                    type="reminder",
                    title="아침 측정 시간",
                    content="공복 혈당을 측정하고 기록해주세요.",
                    priority=4,
                    action_items=["공복 혈당 측정", "아침 식사 계획 확인"],
                    related_goals=[GoalType.GLUCOSE_CONTROL],
                ))
        
        # 점심 (11-13시)
        elif 11 <= hour < 13:
            messages.append(CoachingMessage(
                type="tip",
                title="점심 식사 팁",
                content="채소를 먼저 드시면 혈당 상승을 완화할 수 있습니다.",
                priority=2,
                action_items=["채소 먼저 섭취", "천천히 식사"],
                related_goals=[GoalType.GLUCOSE_CONTROL, GoalType.GENERAL_WELLNESS],
            ))
        
        # 저녁 (17-19시)
        elif 17 <= hour < 19:
            messages.append(CoachingMessage(
                type="reminder",
                title="저녁 운동 시간",
                content="식사 후 30분 뒤 가벼운 산책이 혈당 조절에 도움됩니다.",
                priority=2,
                action_items=["식후 30분 산책"],
                related_goals=[GoalType.GLUCOSE_CONTROL, GoalType.FITNESS_IMPROVEMENT],
            ))
        
        # 밤 (21-23시)
        elif 21 <= hour < 23:
            if GoalType.SLEEP_IMPROVEMENT in profile.goals:
                messages.append(CoachingMessage(
                    type="reminder",
                    title="수면 준비",
                    content="좋은 수면을 위해 전자기기 사용을 줄이세요.",
                    priority=2,
                    action_items=["스마트폰 내려놓기", "조명 낮추기", "취침 1시간 전 카페인 금지"],
                    related_goals=[GoalType.SLEEP_IMPROVEMENT],
                ))
        
        return messages
    
    def _generate_motivation_message(
        self,
        profile: UserProfile,
        measurements: Dict[str, List[float]],
    ) -> Optional[CoachingMessage]:
        """동기부여 메시지 생성"""
        motivational_messages = [
            "작은 변화가 큰 건강을 만듭니다. 오늘도 한 걸음씩!",
            "당신의 건강 관리 노력이 빛나고 있어요!",
            "꾸준함이 최고의 건강 비결입니다.",
            "오늘 하루도 건강하게 보내세요!",
            "자신을 믿으세요. 당신은 할 수 있습니다!",
        ]
        
        import random
        message = random.choice(motivational_messages)
        
        return CoachingMessage(
            type="encouragement",
            title="오늘의 응원",
            content=message,
            priority=1,
            related_goals=profile.goals,
        )
    
    def _generate_meal_plan(self, profile: UserProfile) -> List[Dict[str, Any]]:
        """식사 계획 생성"""
        # 칼로리 계산 (Harris-Benedict 공식 기반)
        if profile.gender == "male":
            bmr = 88.362 + (13.397 * profile.weight) + (4.799 * profile.height) - (5.677 * profile.age)
        else:
            bmr = 447.593 + (9.247 * profile.weight) + (3.098 * profile.height) - (4.330 * profile.age)
        
        activity_multipliers = {
            "sedentary": 1.2,
            "light": 1.375,
            "moderate": 1.55,
            "active": 1.725,
            "very_active": 1.9,
        }
        
        tdee = bmr * activity_multipliers.get(profile.activity_level, 1.55)
        
        # 목표에 따른 칼로리 조정
        if GoalType.WEIGHT_LOSS in profile.goals:
            target_calories = tdee - 500
        elif GoalType.WEIGHT_GAIN in profile.goals:
            target_calories = tdee + 300
        else:
            target_calories = tdee
        
        return [
            {
                "meal": "breakfast",
                "time": "07:00",
                "calories": int(target_calories * 0.25),
                "suggestions": ["통곡물 시리얼", "과일", "저지방 우유"],
            },
            {
                "meal": "lunch",
                "time": "12:00",
                "calories": int(target_calories * 0.35),
                "suggestions": ["현미밥", "구운 생선", "채소 반찬"],
            },
            {
                "meal": "dinner",
                "time": "18:30",
                "calories": int(target_calories * 0.30),
                "suggestions": ["닭가슴살", "샐러드", "잡곡밥"],
            },
            {
                "meal": "snack",
                "time": "15:00",
                "calories": int(target_calories * 0.10),
                "suggestions": ["견과류", "요거트", "과일"],
            },
        ]
    
    def _generate_exercise_plan(self, profile: UserProfile) -> List[Dict[str, Any]]:
        """운동 계획 생성"""
        exercises = []
        
        if profile.activity_level in ["sedentary", "light"]:
            exercises = [
                {"type": "walking", "duration": 20, "time": "07:30", "intensity": "low"},
                {"type": "stretching", "duration": 10, "time": "12:30", "intensity": "low"},
            ]
        elif profile.activity_level == "moderate":
            exercises = [
                {"type": "walking", "duration": 30, "time": "07:00", "intensity": "moderate"},
                {"type": "strength", "duration": 20, "time": "18:00", "intensity": "moderate"},
            ]
        else:
            exercises = [
                {"type": "cardio", "duration": 30, "time": "06:30", "intensity": "high"},
                {"type": "strength", "duration": 30, "time": "18:00", "intensity": "high"},
                {"type": "flexibility", "duration": 15, "time": "21:00", "intensity": "low"},
            ]
        
        return exercises
    
    def _generate_medication_schedule(self, profile: UserProfile) -> List[Dict[str, Any]]:
        """약물 복용 일정 생성"""
        medications = []
        
        for med in profile.medications:
            medications.append({
                "name": med,
                "times": ["08:00", "20:00"],  # 기본값
                "with_meal": True,
            })
        
        return medications
    
    def _generate_measurement_schedule(self, profile: UserProfile) -> List[Dict[str, Any]]:
        """측정 일정 생성"""
        measurements = []
        
        if GoalType.GLUCOSE_CONTROL in profile.goals:
            measurements.extend([
                {"type": "glucose", "time": "07:00", "note": "공복"},
                {"type": "glucose", "time": "10:00", "note": "아침 식후 2시간"},
                {"type": "glucose", "time": "14:00", "note": "점심 식후 2시간"},
                {"type": "glucose", "time": "21:00", "note": "취침 전"},
            ])
        
        if GoalType.BLOOD_PRESSURE_MANAGEMENT in profile.goals:
            measurements.extend([
                {"type": "blood_pressure", "time": "07:30", "note": "아침"},
                {"type": "blood_pressure", "time": "21:30", "note": "저녁"},
            ])
        
        return measurements
    
    def _calculate_sleep_goal(self, profile: UserProfile) -> float:
        """수면 목표 계산"""
        if profile.age < 18:
            return 9.0
        elif profile.age < 65:
            return 8.0
        else:
            return 7.5
    
    def _load_coaching_templates(self) -> Dict[str, List[str]]:
        """코칭 템플릿 로드"""
        return {
            "motivation": [
                "오늘도 건강한 하루 되세요!",
                "작은 습관이 큰 변화를 만듭니다.",
            ],
            "glucose_high": [
                "혈당이 높습니다. 물을 마시고 잠시 걸어보세요.",
            ],
            "glucose_low": [
                "혈당이 낮습니다. 당분을 섭취하세요.",
            ],
        }
    
    def _load_meal_database(self) -> Dict[str, Any]:
        """식단 데이터베이스 로드"""
        return {}  # 실제로는 외부 데이터베이스 연동
    
    def _load_exercise_database(self) -> Dict[str, Any]:
        """운동 데이터베이스 로드"""
        return {}  # 실제로는 외부 데이터베이스 연동


# 싱글톤 인스턴스
_personalized_coach: Optional[PersonalizedCoach] = None


def get_personalized_coach() -> PersonalizedCoach:
    """PersonalizedCoach 싱글톤 인스턴스 반환"""
    global _personalized_coach
    if _personalized_coach is None:
        _personalized_coach = PersonalizedCoach()
    return _personalized_coach

