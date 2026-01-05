"""
AI Medical Coach - Unit Tests
테스트 실행: pytest test_medical_coach.py -v
"""

import pytest
from datetime import datetime
from medical_coach import (
    MedicalExpertBackedCoach, 
    VitalSigns, 
    SeverityLevel,
    VitalSignType
)


class TestSeverityLevel:
    """심각도 수준 테스트"""
    
    def test_severity_order(self):
        """심각도 순서 확인"""
        assert SeverityLevel.LEVEL_1_NORMAL.value < SeverityLevel.LEVEL_2_WARNING.value
        assert SeverityLevel.LEVEL_2_WARNING.value < SeverityLevel.LEVEL_3_URGENT.value
        assert SeverityLevel.LEVEL_3_URGENT.value < SeverityLevel.LEVEL_4_CRITICAL.value


class TestVitalSigns:
    """생리 신호 데이터 테스트"""
    
    def test_valid_vital_signs(self):
        """유효한 생리 신호 생성"""
        vitals = VitalSigns(
            glucose_mg_dl=95.0,
            systolic_bp=120,
            diastolic_bp=80,
            heart_rate_bpm=72,
            temperature_celsius=36.5,
            spo2_percent=98.0
        )
        
        errors = vitals.validate()
        assert len(errors) == 0
    
    def test_invalid_glucose(self):
        """잘못된 혈당 수치 검증"""
        vitals = VitalSigns(
            glucose_mg_dl=500.0,  # 범위 초과
            systolic_bp=120,
            diastolic_bp=80,
            heart_rate_bpm=72,
            temperature_celsius=36.5,
            spo2_percent=98.0
        )
        
        errors = vitals.validate()
        assert len(errors) > 0
        assert any('glucose' in e.lower() for e in errors)
    
    def test_to_dict(self):
        """딕셔너리 변환"""
        vitals = VitalSigns(
            glucose_mg_dl=100.0,
            systolic_bp=118,
            diastolic_bp=78,
            heart_rate_bpm=70,
            temperature_celsius=36.6,
            spo2_percent=99.0
        )
        
        data = vitals.to_dict()
        assert data['glucose_mg_dl'] == 100.0
        assert data['systolic_bp'] == 118


class TestMedicalExpertBackedCoach:
    """의료 전문가 기반 AI 코치 테스트"""
    
    @pytest.fixture
    def coach(self):
        """테스트용 코치 인스턴스"""
        return MedicalExpertBackedCoach(
            patient_id='test_patient_001',
            medical_history={'conditions': [], 'medications': []}
        )
    
    # ========== 혈당 평가 테스트 ==========
    
    def test_normal_glucose(self, coach):
        """정상 혈당 (70-130 mg/dL)"""
        result = coach.assess_glucose(95.0)
        
        assert result['severity'] == SeverityLevel.LEVEL_1_NORMAL
        assert result['diagnosis'] == '정상 혈당'
    
    def test_prediabetes_glucose(self, coach):
        """전당뇨 혈당 (100-125 mg/dL)"""
        result = coach.assess_glucose(115.0)
        
        # 공복일 경우 100-125는 전당뇨
        assert result['severity'] in [SeverityLevel.LEVEL_1_NORMAL, SeverityLevel.LEVEL_2_WARNING]
    
    def test_hypoglycemia_warning(self, coach):
        """저혈당 경고 (50-70 mg/dL)"""
        result = coach.assess_glucose(55.0)
        
        assert result['severity'] in [SeverityLevel.LEVEL_2_WARNING, SeverityLevel.LEVEL_3_URGENT]
        assert '저혈당' in result['diagnosis'] or 'hypoglycemia' in result['diagnosis'].lower()
    
    def test_critical_hypoglycemia(self, coach):
        """심각한 저혈당 (<50 mg/dL) - 응급"""
        result = coach.assess_glucose(40.0)
        
        assert result['severity'] == SeverityLevel.LEVEL_4_CRITICAL
        assert '응급' in result['recommendation'] or '119' in result['recommendation']
    
    def test_high_glucose(self, coach):
        """고혈당 (>180 mg/dL)"""
        result = coach.assess_glucose(200.0)
        
        assert result['severity'] in [SeverityLevel.LEVEL_2_WARNING, SeverityLevel.LEVEL_3_URGENT]
    
    def test_critical_hyperglycemia(self, coach):
        """심각한 고혈당 (>350 mg/dL) - 응급"""
        result = coach.assess_glucose(400.0)
        
        assert result['severity'] == SeverityLevel.LEVEL_4_CRITICAL
    
    # ========== 혈압 평가 테스트 ==========
    
    def test_normal_blood_pressure(self, coach):
        """정상 혈압 (<120/80)"""
        result = coach.assess_blood_pressure(115, 75)
        
        assert result['severity'] == SeverityLevel.LEVEL_1_NORMAL
    
    def test_elevated_blood_pressure(self, coach):
        """상승 혈압 (120-129/<80)"""
        result = coach.assess_blood_pressure(125, 75)
        
        assert result['severity'] in [SeverityLevel.LEVEL_1_NORMAL, SeverityLevel.LEVEL_2_WARNING]
    
    def test_hypertension_stage1(self, coach):
        """고혈압 1단계 (130-139/80-89)"""
        result = coach.assess_blood_pressure(135, 85)
        
        assert result['severity'] == SeverityLevel.LEVEL_2_WARNING
    
    def test_hypertension_stage2(self, coach):
        """고혈압 2단계 (≥140/90)"""
        result = coach.assess_blood_pressure(155, 95)
        
        assert result['severity'] in [SeverityLevel.LEVEL_2_WARNING, SeverityLevel.LEVEL_3_URGENT]
    
    def test_hypertensive_crisis(self, coach):
        """고혈압 위기 (>180/120) - 응급"""
        result = coach.assess_blood_pressure(195, 125)
        
        assert result['severity'] == SeverityLevel.LEVEL_4_CRITICAL
        assert '응급' in result['recommendation'] or '119' in result['recommendation']
    
    # ========== 심박수 평가 테스트 ==========
    
    def test_normal_heart_rate(self, coach):
        """정상 심박수 (60-100 bpm)"""
        result = coach.assess_heart_rate(72)
        
        assert result['severity'] == SeverityLevel.LEVEL_1_NORMAL
    
    def test_bradycardia(self, coach):
        """서맥 (<60 bpm)"""
        result = coach.assess_heart_rate(50)
        
        assert result['severity'] in [SeverityLevel.LEVEL_1_NORMAL, SeverityLevel.LEVEL_2_WARNING]
    
    def test_tachycardia(self, coach):
        """빈맥 (>100 bpm)"""
        result = coach.assess_heart_rate(115)
        
        assert result['severity'] in [SeverityLevel.LEVEL_2_WARNING, SeverityLevel.LEVEL_3_URGENT]
    
    def test_critical_heart_rate(self, coach):
        """위험 심박수 (<40 or >150 bpm)"""
        result_low = coach.assess_heart_rate(35)
        result_high = coach.assess_heart_rate(160)
        
        assert result_low['severity'] in [SeverityLevel.LEVEL_3_URGENT, SeverityLevel.LEVEL_4_CRITICAL]
        assert result_high['severity'] in [SeverityLevel.LEVEL_3_URGENT, SeverityLevel.LEVEL_4_CRITICAL]
    
    # ========== 체온 평가 테스트 ==========
    
    def test_normal_temperature(self, coach):
        """정상 체온 (36.1-37.2°C)"""
        result = coach.assess_temperature(36.5)
        
        assert result['severity'] == SeverityLevel.LEVEL_1_NORMAL
    
    def test_fever(self, coach):
        """발열 (>37.5°C)"""
        result = coach.assess_temperature(38.5)
        
        assert result['severity'] in [SeverityLevel.LEVEL_2_WARNING, SeverityLevel.LEVEL_3_URGENT]
    
    def test_high_fever(self, coach):
        """고열 (>40°C) - 위험"""
        result = coach.assess_temperature(40.5)
        
        assert result['severity'] in [SeverityLevel.LEVEL_3_URGENT, SeverityLevel.LEVEL_4_CRITICAL]
    
    # ========== 종합 평가 테스트 ==========
    
    def test_comprehensive_normal(self, coach):
        """종합 평가 - 모든 수치 정상"""
        vitals = VitalSigns(
            glucose_mg_dl=95.0,
            systolic_bp=118,
            diastolic_bp=78,
            heart_rate_bpm=72,
            temperature_celsius=36.5,
            spo2_percent=98.0
        )
        
        result = coach.comprehensive_assessment(vitals)
        
        assert result['overall_severity'] == SeverityLevel.LEVEL_1_NORMAL
        assert result['is_emergency'] == False
        assert result['confidence'] >= 0.8
    
    def test_comprehensive_emergency(self, coach):
        """종합 평가 - 응급 상황"""
        vitals = VitalSigns(
            glucose_mg_dl=40.0,  # 심각한 저혈당
            systolic_bp=190,     # 고혈압 위기
            diastolic_bp=125,
            heart_rate_bpm=140,
            temperature_celsius=36.5,
            spo2_percent=98.0
        )
        
        result = coach.comprehensive_assessment(vitals)
        
        assert result['is_emergency'] == True
        assert result['overall_severity'] == SeverityLevel.LEVEL_4_CRITICAL
    
    # ========== 응급 상황 감지 테스트 ==========
    
    def test_emergency_detection_hypoglycemia(self, coach):
        """응급 감지 - 저혈당"""
        vitals = VitalSigns(
            glucose_mg_dl=35.0,
            systolic_bp=120,
            diastolic_bp=80,
            heart_rate_bpm=72,
            temperature_celsius=36.5,
            spo2_percent=98.0
        )
        
        is_emergency, reasons, action = coach.emergency_detection(vitals)
        
        assert is_emergency == True
        assert any('저혈당' in r or 'glucose' in r.lower() for r in reasons)
        assert '119' in action or '응급' in action
    
    def test_emergency_detection_normal(self, coach):
        """응급 아님 - 정상 수치"""
        vitals = VitalSigns(
            glucose_mg_dl=100.0,
            systolic_bp=120,
            diastolic_bp=80,
            heart_rate_bpm=72,
            temperature_celsius=36.5,
            spo2_percent=98.0
        )
        
        is_emergency, reasons, action = coach.emergency_detection(vitals)
        
        assert is_emergency == False


class TestClinicalGuidelines:
    """임상 가이드라인 검증 테스트"""
    
    def test_ada_glucose_guidelines(self):
        """ADA 혈당 가이드라인 준수"""
        # ADA 기준: 정상 공복 혈당 70-100 mg/dL
        coach = MedicalExpertBackedCoach('test')
        
        # 정상 범위
        assert coach.assess_glucose(80)['severity'] == SeverityLevel.LEVEL_1_NORMAL
        
        # 전당뇨 (100-125)
        result = coach.assess_glucose(110)
        assert result['severity'] in [SeverityLevel.LEVEL_1_NORMAL, SeverityLevel.LEVEL_2_WARNING]
        
        # 당뇨 기준 (≥126)
        result = coach.assess_glucose(130)
        assert result['severity'] != SeverityLevel.LEVEL_1_NORMAL
    
    def test_aha_blood_pressure_guidelines(self):
        """ACC/AHA 혈압 가이드라인 준수"""
        coach = MedicalExpertBackedCoach('test')
        
        # 정상: <120/80
        assert coach.assess_blood_pressure(115, 75)['severity'] == SeverityLevel.LEVEL_1_NORMAL
        
        # 고혈압 위기: >180/120
        crisis = coach.assess_blood_pressure(190, 130)
        assert crisis['severity'] == SeverityLevel.LEVEL_4_CRITICAL


# 테스트 실행
if __name__ == '__main__':
    pytest.main([__file__, '-v', '--tb=short'])
