"""
건강 예측 ML 모델
LSTM, Transformer, XGBoost 기반 예측 모델
"""

import numpy as np
from typing import List, Dict, Optional, Tuple
from dataclasses import dataclass
from enum import Enum
import logging

# 실제 환경에서는 아래 import 사용
# import torch
# import torch.nn as nn
# from sklearn.ensemble import GradientBoostingRegressor
# import xgboost as xgb

logger = logging.getLogger(__name__)


class PredictionType(Enum):
    """예측 유형"""
    GLUCOSE = "glucose"
    BLOOD_PRESSURE = "blood_pressure"
    HEART_RATE = "heart_rate"
    HEALTH_SCORE = "health_score"
    RISK_ASSESSMENT = "risk_assessment"


@dataclass
class PredictionResult:
    """예측 결과"""
    prediction_type: PredictionType
    value: float
    confidence: float
    lower_bound: float
    upper_bound: float
    trend: str  # "increasing", "decreasing", "stable"
    risk_level: str  # "low", "medium", "high", "critical"
    recommendations: List[str]
    timestamp: str


class TimeSeriesFeatureExtractor:
    """시계열 특성 추출기"""
    
    @staticmethod
    def extract_features(data: np.ndarray) -> Dict[str, float]:
        """시계열 데이터에서 통계적 특성 추출"""
        if len(data) == 0:
            return {}
        
        return {
            "mean": float(np.mean(data)),
            "std": float(np.std(data)),
            "min": float(np.min(data)),
            "max": float(np.max(data)),
            "range": float(np.max(data) - np.min(data)),
            "median": float(np.median(data)),
            "q25": float(np.percentile(data, 25)),
            "q75": float(np.percentile(data, 75)),
            "iqr": float(np.percentile(data, 75) - np.percentile(data, 25)),
            "skewness": float(TimeSeriesFeatureExtractor._skewness(data)),
            "kurtosis": float(TimeSeriesFeatureExtractor._kurtosis(data)),
            "trend_slope": float(TimeSeriesFeatureExtractor._trend_slope(data)),
            "volatility": float(np.std(np.diff(data)) if len(data) > 1 else 0),
        }
    
    @staticmethod
    def _skewness(data: np.ndarray) -> float:
        """왜도 계산"""
        n = len(data)
        if n < 3:
            return 0.0
        mean = np.mean(data)
        std = np.std(data)
        if std == 0:
            return 0.0
        return float(np.mean(((data - mean) / std) ** 3))
    
    @staticmethod
    def _kurtosis(data: np.ndarray) -> float:
        """첨도 계산"""
        n = len(data)
        if n < 4:
            return 0.0
        mean = np.mean(data)
        std = np.std(data)
        if std == 0:
            return 0.0
        return float(np.mean(((data - mean) / std) ** 4) - 3)
    
    @staticmethod
    def _trend_slope(data: np.ndarray) -> float:
        """추세 기울기 계산 (선형 회귀)"""
        if len(data) < 2:
            return 0.0
        x = np.arange(len(data))
        slope = np.polyfit(x, data, 1)[0]
        return float(slope)


class LSTMPredictor:
    """LSTM 기반 시계열 예측 모델"""
    
    def __init__(
        self,
        input_size: int = 1,
        hidden_size: int = 64,
        num_layers: int = 2,
        output_size: int = 1,
        sequence_length: int = 24,
    ):
        self.input_size = input_size
        self.hidden_size = hidden_size
        self.num_layers = num_layers
        self.output_size = output_size
        self.sequence_length = sequence_length
        self.model = None
        self._initialize_model()
    
    def _initialize_model(self):
        """모델 초기화 (시뮬레이션)"""
        # 실제 환경에서는 PyTorch LSTM 모델 초기화
        logger.info(f"LSTM model initialized: hidden={self.hidden_size}, layers={self.num_layers}")
    
    def predict(self, sequence: np.ndarray) -> Tuple[float, float]:
        """
        예측 수행
        
        Args:
            sequence: 입력 시퀀스 (sequence_length x input_size)
            
        Returns:
            (예측값, 신뢰도)
        """
        # 시뮬레이션: 실제로는 모델 추론 수행
        if len(sequence) < self.sequence_length:
            # 패딩
            padded = np.zeros((self.sequence_length, self.input_size))
            padded[-len(sequence):] = sequence.reshape(-1, self.input_size)
            sequence = padded
        
        # 간단한 예측 시뮬레이션 (이동 평균 + 추세)
        recent_values = sequence[-7:]
        mean_val = np.mean(recent_values)
        trend = TimeSeriesFeatureExtractor._trend_slope(recent_values.flatten())
        
        prediction = mean_val + trend
        confidence = max(0.5, 1.0 - abs(trend) / mean_val) if mean_val != 0 else 0.5
        
        return float(prediction), float(confidence)
    
    def train(self, X: np.ndarray, y: np.ndarray, epochs: int = 100):
        """모델 학습"""
        # 실제 환경에서는 PyTorch 학습 루프
        logger.info(f"Training LSTM with {len(X)} samples for {epochs} epochs")


class TransformerPredictor:
    """Transformer 기반 시계열 예측 모델"""
    
    def __init__(
        self,
        d_model: int = 64,
        nhead: int = 4,
        num_encoder_layers: int = 2,
        dim_feedforward: int = 256,
        sequence_length: int = 48,
    ):
        self.d_model = d_model
        self.nhead = nhead
        self.num_encoder_layers = num_encoder_layers
        self.dim_feedforward = dim_feedforward
        self.sequence_length = sequence_length
        self.model = None
        self._initialize_model()
    
    def _initialize_model(self):
        """모델 초기화"""
        logger.info(f"Transformer model initialized: d_model={self.d_model}, heads={self.nhead}")
    
    def predict(self, sequence: np.ndarray, horizon: int = 1) -> List[Tuple[float, float]]:
        """
        다중 시점 예측
        
        Args:
            sequence: 입력 시퀀스
            horizon: 예측 시점 수
            
        Returns:
            [(예측값, 신뢰도), ...]
        """
        predictions = []
        current_seq = sequence.copy()
        
        for i in range(horizon):
            # 간단한 예측 시뮬레이션
            mean_val = np.mean(current_seq[-14:])
            std_val = np.std(current_seq[-14:])
            trend = TimeSeriesFeatureExtractor._trend_slope(current_seq[-14:])
            
            pred = mean_val + trend * (i + 1)
            conf = max(0.3, 0.9 - 0.1 * i)  # 멀수록 신뢰도 감소
            
            predictions.append((float(pred), float(conf)))
            current_seq = np.append(current_seq, pred)
        
        return predictions


class XGBoostPredictor:
    """XGBoost 기반 예측 모델"""
    
    def __init__(self, n_estimators: int = 100, max_depth: int = 6):
        self.n_estimators = n_estimators
        self.max_depth = max_depth
        self.model = None
        self._initialize_model()
    
    def _initialize_model(self):
        """모델 초기화"""
        logger.info(f"XGBoost model initialized: n_estimators={self.n_estimators}")
    
    def predict(self, features: Dict[str, float]) -> Tuple[float, float]:
        """
        특성 기반 예측
        
        Args:
            features: 입력 특성 딕셔너리
            
        Returns:
            (예측값, 신뢰도)
        """
        # 특성을 벡터로 변환
        feature_values = list(features.values())
        
        # 시뮬레이션: 가중 평균 기반 예측
        if "mean" in features:
            prediction = features["mean"] * 0.7 + features.get("median", features["mean"]) * 0.3
        else:
            prediction = np.mean(feature_values) if feature_values else 0
        
        # 신뢰도 계산 (변동성 기반)
        volatility = features.get("volatility", 0)
        confidence = max(0.5, 1.0 - volatility / 10) if volatility else 0.8
        
        return float(prediction), float(confidence)
    
    def predict_risk(self, features: Dict[str, float]) -> Dict[str, float]:
        """
        건강 위험도 예측
        
        Args:
            features: 건강 지표 특성
            
        Returns:
            위험도 점수 (0-1)
        """
        risk_scores = {}
        
        # 혈당 위험도
        if "glucose_mean" in features:
            glucose = features["glucose_mean"]
            if glucose < 70:
                risk_scores["hypoglycemia"] = min(1.0, (70 - glucose) / 30)
            elif glucose > 126:
                risk_scores["hyperglycemia"] = min(1.0, (glucose - 126) / 100)
            else:
                risk_scores["glucose"] = 0.0
        
        # 혈압 위험도
        if "systolic_mean" in features:
            systolic = features["systolic_mean"]
            if systolic > 140:
                risk_scores["hypertension"] = min(1.0, (systolic - 140) / 40)
            elif systolic < 90:
                risk_scores["hypotension"] = min(1.0, (90 - systolic) / 30)
        
        # 종합 위험도
        if risk_scores:
            risk_scores["overall"] = min(1.0, max(risk_scores.values()))
        else:
            risk_scores["overall"] = 0.0
        
        return risk_scores


class HealthPredictor:
    """
    종합 건강 예측 시스템
    다중 모델 앙상블
    """
    
    def __init__(self):
        self.lstm_predictor = LSTMPredictor()
        self.transformer_predictor = TransformerPredictor()
        self.xgboost_predictor = XGBoostPredictor()
        self.feature_extractor = TimeSeriesFeatureExtractor()
    
    def predict_glucose(
        self,
        history: List[float],
        horizon_hours: int = 4,
    ) -> PredictionResult:
        """
        혈당 예측
        
        Args:
            history: 과거 혈당 측정값 (시간순)
            horizon_hours: 예측 시간 (시간)
            
        Returns:
            예측 결과
        """
        sequence = np.array(history)
        features = self.feature_extractor.extract_features(sequence)
        
        # 앙상블 예측
        lstm_pred, lstm_conf = self.lstm_predictor.predict(sequence)
        transformer_preds = self.transformer_predictor.predict(sequence, horizon=horizon_hours)
        xgb_pred, xgb_conf = self.xgboost_predictor.predict(features)
        
        # 가중 평균 앙상블
        weights = [lstm_conf, transformer_preds[0][1] if transformer_preds else 0.5, xgb_conf]
        total_weight = sum(weights)
        
        predictions = [lstm_pred, transformer_preds[0][0] if transformer_preds else lstm_pred, xgb_pred]
        final_prediction = sum(p * w for p, w in zip(predictions, weights)) / total_weight
        final_confidence = np.mean(weights)
        
        # 신뢰 구간 계산
        std = features.get("std", 10)
        lower = final_prediction - 1.96 * std
        upper = final_prediction + 1.96 * std
        
        # 추세 분석
        trend_slope = features.get("trend_slope", 0)
        if trend_slope > 2:
            trend = "increasing"
        elif trend_slope < -2:
            trend = "decreasing"
        else:
            trend = "stable"
        
        # 위험도 평가
        if final_prediction < 70 or final_prediction > 180:
            risk_level = "critical"
        elif final_prediction < 80 or final_prediction > 140:
            risk_level = "high"
        elif final_prediction < 90 or final_prediction > 120:
            risk_level = "medium"
        else:
            risk_level = "low"
        
        # 권장사항 생성
        recommendations = self._generate_glucose_recommendations(
            final_prediction, trend, risk_level
        )
        
        return PredictionResult(
            prediction_type=PredictionType.GLUCOSE,
            value=final_prediction,
            confidence=final_confidence,
            lower_bound=lower,
            upper_bound=upper,
            trend=trend,
            risk_level=risk_level,
            recommendations=recommendations,
            timestamp=str(np.datetime64('now')),
        )
    
    def predict_health_score(
        self,
        measurements: Dict[str, List[float]],
    ) -> PredictionResult:
        """
        종합 건강 점수 예측
        
        Args:
            measurements: 측정 데이터 딕셔너리
            
        Returns:
            예측 결과
        """
        # 각 지표별 점수 계산
        scores = {}
        
        if "glucose" in measurements:
            glucose_features = self.feature_extractor.extract_features(
                np.array(measurements["glucose"])
            )
            scores["glucose"] = self._calculate_glucose_score(glucose_features)
        
        if "blood_pressure" in measurements:
            bp_features = self.feature_extractor.extract_features(
                np.array(measurements["blood_pressure"])
            )
            scores["blood_pressure"] = self._calculate_bp_score(bp_features)
        
        if "heart_rate" in measurements:
            hr_features = self.feature_extractor.extract_features(
                np.array(measurements["heart_rate"])
            )
            scores["heart_rate"] = self._calculate_hr_score(hr_features)
        
        if "oxygen" in measurements:
            o2_features = self.feature_extractor.extract_features(
                np.array(measurements["oxygen"])
            )
            scores["oxygen"] = self._calculate_oxygen_score(o2_features)
        
        # 가중 평균 건강 점수
        weights = {
            "glucose": 0.3,
            "blood_pressure": 0.25,
            "heart_rate": 0.2,
            "oxygen": 0.25,
        }
        
        total_score = 0
        total_weight = 0
        for key, score in scores.items():
            weight = weights.get(key, 0.25)
            total_score += score * weight
            total_weight += weight
        
        health_score = total_score / total_weight if total_weight > 0 else 50
        
        # 위험도
        if health_score >= 90:
            risk_level = "low"
        elif health_score >= 75:
            risk_level = "medium"
        elif health_score >= 60:
            risk_level = "high"
        else:
            risk_level = "critical"
        
        return PredictionResult(
            prediction_type=PredictionType.HEALTH_SCORE,
            value=health_score,
            confidence=0.85,
            lower_bound=health_score - 5,
            upper_bound=health_score + 5,
            trend="stable",
            risk_level=risk_level,
            recommendations=self._generate_health_recommendations(scores, risk_level),
            timestamp=str(np.datetime64('now')),
        )
    
    def _calculate_glucose_score(self, features: Dict[str, float]) -> float:
        """혈당 점수 계산"""
        mean = features.get("mean", 100)
        std = features.get("std", 20)
        
        # 정상 범위: 70-100 (공복)
        if 70 <= mean <= 100:
            base_score = 100
        elif mean < 70:
            base_score = max(0, 100 - (70 - mean) * 2)
        else:
            base_score = max(0, 100 - (mean - 100) * 1.5)
        
        # 변동성 페널티
        variability_penalty = min(20, std / 2)
        
        return max(0, base_score - variability_penalty)
    
    def _calculate_bp_score(self, features: Dict[str, float]) -> float:
        """혈압 점수 계산"""
        mean = features.get("mean", 120)
        
        if mean < 120:
            return 100
        elif mean < 130:
            return 90
        elif mean < 140:
            return 75
        else:
            return max(0, 100 - (mean - 120))
    
    def _calculate_hr_score(self, features: Dict[str, float]) -> float:
        """심박수 점수 계산"""
        mean = features.get("mean", 72)
        
        if 60 <= mean <= 80:
            return 100
        elif 50 <= mean <= 100:
            return 85
        else:
            return max(0, 100 - abs(mean - 70))
    
    def _calculate_oxygen_score(self, features: Dict[str, float]) -> float:
        """산소포화도 점수 계산"""
        mean = features.get("mean", 98)
        
        if mean >= 98:
            return 100
        elif mean >= 95:
            return 90
        elif mean >= 90:
            return 70
        else:
            return max(0, mean)
    
    def _generate_glucose_recommendations(
        self,
        prediction: float,
        trend: str,
        risk_level: str,
    ) -> List[str]:
        """혈당 관련 권장사항 생성"""
        recommendations = []
        
        if prediction < 70:
            recommendations.append("혈당이 낮습니다. 당분을 섭취하세요.")
            recommendations.append("증상이 지속되면 의료진과 상담하세요.")
        elif prediction > 140:
            recommendations.append("혈당이 높습니다. 식이 조절이 필요합니다.")
            recommendations.append("가벼운 운동을 권장합니다.")
        
        if trend == "increasing":
            recommendations.append("혈당이 상승 추세입니다. 식사량을 조절하세요.")
        elif trend == "decreasing" and prediction < 100:
            recommendations.append("혈당 하락 추세입니다. 간식을 준비해두세요.")
        
        if risk_level in ["high", "critical"]:
            recommendations.append("정기적인 측정과 의료진 상담을 권장합니다.")
        
        if not recommendations:
            recommendations.append("현재 혈당 수치가 정상 범위입니다. 좋은 관리를 유지하세요.")
        
        return recommendations
    
    def _generate_health_recommendations(
        self,
        scores: Dict[str, float],
        risk_level: str,
    ) -> List[str]:
        """건강 관련 종합 권장사항 생성"""
        recommendations = []
        
        # 가장 낮은 점수 항목 확인
        if scores:
            lowest_key = min(scores, key=scores.get)
            lowest_score = scores[lowest_key]
            
            if lowest_score < 70:
                if lowest_key == "glucose":
                    recommendations.append("혈당 관리에 주의가 필요합니다.")
                elif lowest_key == "blood_pressure":
                    recommendations.append("혈압 관리에 주의가 필요합니다.")
                elif lowest_key == "heart_rate":
                    recommendations.append("심박수가 불안정합니다. 휴식을 취하세요.")
                elif lowest_key == "oxygen":
                    recommendations.append("산소포화도가 낮습니다. 호흡을 깊게 하세요.")
        
        if risk_level == "low":
            recommendations.append("전반적인 건강 상태가 양호합니다.")
        elif risk_level == "critical":
            recommendations.append("즉시 의료진과 상담하시기 바랍니다.")
        
        recommendations.append("규칙적인 측정을 계속해주세요.")
        
        return recommendations


# 모델 인스턴스 (싱글톤)
_health_predictor: Optional[HealthPredictor] = None


def get_health_predictor() -> HealthPredictor:
    """HealthPredictor 싱글톤 인스턴스 반환"""
    global _health_predictor
    if _health_predictor is None:
        _health_predictor = HealthPredictor()
    return _health_predictor

