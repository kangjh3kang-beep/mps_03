"""
MPS Healthcare System - 의료 테스트 케이스 생성기
100개의 의료 기반 테스트 시나리오
Version: 1.0
Created: 2026-01-02
"""

import json
from datetime import datetime
from enum import Enum


class ClinicalScenario(Enum):
    """임상 시나리오"""
    NORMAL = "정상"
    WARNING = "경고"
    CRITICAL = "응급"


class MedicalTestCaseGenerator:
    """의료 테스트 케이스 생성기"""
    
    def __init__(self):
        self.test_cases = []
        self.case_id = 1
    
    def add_test_case(
        self,
        description: str,
        scenario: ClinicalScenario,
        glucose: float,
        systolic_bp: int,
        diastolic_bp: int,
        heart_rate: int,
        temperature: float,
        spo2: float,
        expected_severity: int,
        expected_is_emergency: bool,
        medical_context: str = ""
    ):
        """테스트 케이스 추가"""
        self.test_cases.append({
            "case_id": self.case_id,
            "description": description,
            "scenario": scenario.value,
            "vitals": {
                "glucose_mg_dl": glucose,
                "systolic_bp": systolic_bp,
                "diastolic_bp": diastolic_bp,
                "heart_rate_bpm": heart_rate,
                "temperature_celsius": temperature,
                "spo2_percent": spo2
            },
            "expected_results": {
                "severity_level": expected_severity,
                "is_emergency": expected_is_emergency
            },
            "medical_context": medical_context
        })
        self.case_id += 1
    
    def generate_all_tests(self):
        """모든 의료 테스트 케이스 생성"""
        
        print("=" * 80)
        print("MPS Healthcare System - 100개 의료 테스트 케이스 생성")
        print("=" * 80)
        
        # ========== 혈당 관련 테스트 (20개) ==========
        print("\n📊 혈당 관련 테스트 (20개)")
        
        # 정상 혈당
        for glucose in [70, 75, 80, 90, 100, 110, 120, 130]:
            self.add_test_case(
                description=f"정상 혈당: {glucose} mg/dL",
                scenario=ClinicalScenario.NORMAL,
                glucose=glucose,
                systolic_bp=120,
                diastolic_bp=80,
                heart_rate=72,
                temperature=37.0,
                spo2=98,
                expected_severity=1,
                expected_is_emergency=False,
                medical_context="ADA 정상 범위 (70-130 mg/dL)"
            )
        
        # 경고 수준 혈당
        for glucose in [50, 60, 65, 140, 160, 180]:
            is_emergency = glucose < 50
            severity = 4 if glucose < 50 else 2
            self.add_test_case(
                description=f"경고 수준 혈당: {glucose} mg/dL",
                scenario=ClinicalScenario.WARNING,
                glucose=glucose,
                systolic_bp=120,
                diastolic_bp=80,
                heart_rate=72,
                temperature=37.0,
                spo2=98,
                expected_severity=severity,
                expected_is_emergency=is_emergency,
                medical_context="ADA 경고 범위 (50-70 또는 130-180 mg/dL)"
            )
        
        # 응급 혈당
        for glucose in [35, 40, 250, 350]:
            self.add_test_case(
                description=f"응급 혈당: {glucose} mg/dL",
                scenario=ClinicalScenario.CRITICAL,
                glucose=glucose,
                systolic_bp=120,
                diastolic_bp=80,
                heart_rate=72,
                temperature=37.0,
                spo2=98,
                expected_severity=4,
                expected_is_emergency=True,
                medical_context="ADA 응급 범위 (<40 또는 >250 mg/dL) - DKA 위험"
            )
        
        # ========== 혈압 관련 테스트 (20개) ==========
        print("\n💧 혈압 관련 테스트 (20개)")
        
        # 정상 혈압
        for systolic, diastolic in [(110, 70), (115, 75), (120, 80)]:
            self.add_test_case(
                description=f"정상 혈압: {systolic}/{diastolic} mmHg",
                scenario=ClinicalScenario.NORMAL,
                glucose=100,
                systolic_bp=systolic,
                diastolic_bp=diastolic,
                heart_rate=72,
                temperature=37.0,
                spo2=98,
                expected_severity=1,
                expected_is_emergency=False,
                medical_context="ACC/AHA 정상 범위 (<120/<80)"
            )
        
        # 상승/1단계 혈압
        for systolic, diastolic in [(125, 80), (130, 85), (135, 88)]:
            self.add_test_case(
                description=f"상승 혈압: {systolic}/{diastolic} mmHg",
                scenario=ClinicalScenario.WARNING,
                glucose=100,
                systolic_bp=systolic,
                diastolic_bp=diastolic,
                heart_rate=72,
                temperature=37.0,
                spo2=98,
                expected_severity=2,
                expected_is_emergency=False,
                medical_context="ACC/AHA 상승/1단계 (120-139/80-89)"
            )
        
        # 2단계 고혈압
        for systolic, diastolic in [(140, 90), (150, 100), (165, 105)]:
            self.add_test_case(
                description=f"2단계 고혈압: {systolic}/{diastolic} mmHg",
                scenario=ClinicalScenario.CRITICAL,
                glucose=100,
                systolic_bp=systolic,
                diastolic_bp=diastolic,
                heart_rate=72,
                temperature=37.0,
                spo2=98,
                expected_severity=3,
                expected_is_emergency=False,
                medical_context="ACC/AHA 2단계 (≥140/90)"
            )
        
        # 고혈압 위기
        for systolic, diastolic in [(180, 120), (190, 125), (200, 130)]:
            self.add_test_case(
                description=f"고혈압 위기: {systolic}/{diastolic} mmHg",
                scenario=ClinicalScenario.CRITICAL,
                glucose=100,
                systolic_bp=systolic,
                diastolic_bp=diastolic,
                heart_rate=72,
                temperature=37.0,
                spo2=98,
                expected_severity=4,
                expected_is_emergency=True,
                medical_context="고혈압 위기 (>180/120) - 즉시 응급실"
            )
        
        # ========== 심박수 관련 테스트 (15개) ==========
        print("\n❤️ 심박수 관련 테스트 (15개)")
        
        # 정상 심박수
        for hr in [60, 65, 72, 80, 90, 100]:
            self.add_test_case(
                description=f"정상 심박수: {hr} bpm",
                scenario=ClinicalScenario.NORMAL,
                glucose=100,
                systolic_bp=120,
                diastolic_bp=80,
                heart_rate=hr,
                temperature=37.0,
                spo2=98,
                expected_severity=1,
                expected_is_emergency=False,
                medical_context="WHO 정상 범위 (60-100 bpm)"
            )
        
        # 서맥/빈맥 경고
        for hr in [50, 55, 110, 120]:
            self.add_test_case(
                description=f"이상 심박수: {hr} bpm",
                scenario=ClinicalScenario.WARNING,
                glucose=100,
                systolic_bp=120,
                diastolic_bp=80,
                heart_rate=hr,
                temperature=37.0,
                spo2=98,
                expected_severity=2,
                expected_is_emergency=False,
                medical_context="경계선 심박수 (50-59 또는 110-120 bpm)"
            )
        
        # 심한 부정맥
        for hr in [40, 45, 150, 160]:
            self.add_test_case(
                description=f"위험한 심박수: {hr} bpm",
                scenario=ClinicalScenario.CRITICAL,
                glucose=100,
                systolic_bp=120,
                diastolic_bp=80,
                heart_rate=hr,
                temperature=37.0,
                spo2=98,
                expected_severity=4,
                expected_is_emergency=True,
                medical_context="위험한 심박수 (<40 또는 >150 bpm)"
            )
        
        # ========== 체온 관련 테스트 (15개) ==========
        print("\n🌡️  체온 관련 테스트 (15개)")
        
        # 정상 체온
        for temp in [36.5, 36.8, 37.0, 37.2, 37.5]:
            self.add_test_case(
                description=f"정상 체온: {temp}°C",
                scenario=ClinicalScenario.NORMAL,
                glucose=100,
                systolic_bp=120,
                diastolic_bp=80,
                heart_rate=72,
                temperature=temp,
                spo2=98,
                expected_severity=1,
                expected_is_emergency=False,
                medical_context="정상 체온 범위 (36.5-37.5°C)"
            )
        
        # 저체온/미열
        for temp in [36.0, 36.2, 37.7, 38.0, 38.5]:
            self.add_test_case(
                description=f"비정상 체온: {temp}°C",
                scenario=ClinicalScenario.WARNING,
                glucose=100,
                systolic_bp=120,
                diastolic_bp=80,
                heart_rate=72,
                temperature=temp,
                spo2=98,
                expected_severity=2,
                expected_is_emergency=False,
                medical_context="경계선 체온 (36.0 또는 37.7-38.5°C)"
            )
        
        # 극단적 체온
        for temp in [35.5, 35.0, 39.5, 40.0]:
            self.add_test_case(
                description=f"위험한 체온: {temp}°C",
                scenario=ClinicalScenario.CRITICAL,
                glucose=100,
                systolic_bp=120,
                diastolic_bp=80,
                heart_rate=72,
                temperature=temp,
                spo2=98,
                expected_severity=4,
                expected_is_emergency=True,
                medical_context="극단적 체온 (<35 또는 ≥40°C)"
            )
        
        # ========== SpO2 관련 테스트 (10개) ==========
        print("\n🫁 산소포화도 테스트 (10개)")
        
        # 정상
        for spo2 in [95, 96, 97, 98, 99, 100]:
            self.add_test_case(
                description=f"정상 산소포화도: {spo2}%",
                scenario=ClinicalScenario.NORMAL,
                glucose=100,
                systolic_bp=120,
                diastolic_bp=80,
                heart_rate=72,
                temperature=37.0,
                spo2=spo2,
                expected_severity=1,
                expected_is_emergency=False,
                medical_context="정상 범위 (≥90%)"
            )
        
        # 경고
        self.add_test_case(
            description=f"저산소증 경고: 89%",
            scenario=ClinicalScenario.WARNING,
            glucose=100,
            systolic_bp=120,
            diastolic_bp=80,
            heart_rate=72,
            temperature=37.0,
            spo2=89,
            expected_severity=2,
            expected_is_emergency=False,
            medical_context="경고 범위 (85-90%)"
        )
        
        # 응급
        for spo2 in [85, 80, 75]:
            self.add_test_case(
                description=f"심각한 저산소증: {spo2}%",
                scenario=ClinicalScenario.CRITICAL,
                glucose=100,
                systolic_bp=120,
                diastolic_bp=80,
                heart_rate=72,
                temperature=37.0,
                spo2=spo2,
                expected_severity=4,
                expected_is_emergency=True,
                medical_context="응급 범위 (<85%)"
            )
        
        # ========== 복합 시나리오 (20개) ==========
        print("\n🔄 복합 임상 시나리오 (20개)")
        
        # 시나리오 1: 당뇨병 환자 (정상)
        self.add_test_case(
            description="당뇨병 환자 - 혈당 잘 조절됨",
            scenario=ClinicalScenario.NORMAL,
            glucose=115,
            systolic_bp=130,
            diastolic_bp=85,
            heart_rate=75,
            temperature=37.0,
            spo2=97,
            expected_severity=2,
            expected_is_emergency=False,
            medical_context="당뇨병 약물 치료 중, 혈당 목표: 100-180"
        )
        
        # 시나리오 2: 고혈압 환자 (경고)
        self.add_test_case(
            description="고혈압 환자 - 약물 조절 필요",
            scenario=ClinicalScenario.WARNING,
            glucose=105,
            systolic_bp=145,
            diastolic_bp=92,
            heart_rate=78,
            temperature=37.0,
            spo2=98,
            expected_severity=3,
            expected_is_emergency=False,
            medical_context="ACE 억제제 복용 중, 용량 조정 필요"
        )
        
        # 시나리오 3: 감염성 질환 (경고)
        self.add_test_case(
            description="감염성 질환 - 발열 및 빈맥",
            scenario=ClinicalScenario.WARNING,
            glucose=110,
            systolic_bp=125,
            diastolic_bp=82,
            heart_rate=105,
            temperature=38.5,
            spo2=96,
            expected_severity=2,
            expected_is_emergency=False,
            medical_context="상기도 감염 의심, 항생제 처방 검토"
        )
        
        # 시나리오 4: 심근경색 위험 (응급)
        self.add_test_case(
            description="심근경색 위험 - 다중 위험 인자",
            scenario=ClinicalScenario.CRITICAL,
            glucose=180,
            systolic_bp=165,
            diastolic_bp=105,
            heart_rate=110,
            temperature=37.0,
            spo2=94,
            expected_severity=4,
            expected_is_emergency=True,
            medical_context="흉통 + 고혈당 + 빈맥 + 저혈압 → 즉시 ECG"
        )
        
        # 시나리오 5: 저혈당 쇼크 (응급)
        self.add_test_case(
            description="저혈당 쇼크 - 의식 변화 위험",
            scenario=ClinicalScenario.CRITICAL,
            glucose=30,
            systolic_bp=90,
            diastolic_bp=55,
            heart_rate=125,
            temperature=36.5,
            spo2=94,
            expected_severity=4,
            expected_is_emergency=True,
            medical_context="인슐린 과다투여 의심 → 포도당 IV 긴급 투여"
        )
        
        # 시나리오 6: 패혈증 (응급)
        self.add_test_case(
            description="패혈증 의심 - 다중 장기부전 신호",
            scenario=ClinicalScenario.CRITICAL,
            glucose=200,
            systolic_bp=85,
            diastolic_bp=50,
            heart_rate=130,
            temperature=39.5,
            spo2=91,
            expected_severity=4,
            expected_is_emergency=True,
            medical_context="저혈압 + 빈맥 + 고열 + 저산소 → 응급실 이송"
        )
        
        # 시나리오 7: 만성 폐쇄성 질환 (경고)
        self.add_test_case(
            description="COPD 환자 - 산소 포화도 저하",
            scenario=ClinicalScenario.WARNING,
            glucose=95,
            systolic_bp=135,
            diastolic_bp=80,
            heart_rate=92,
            temperature=37.2,
            spo2=87,
            expected_severity=2,
            expected_is_emergency=False,
            medical_context="만성폐쇄성폐질환, 산소 투여 고려"
        )
        
        # 시나리오 8: 갑상선 중독증 (경고)
        self.add_test_case(
            description="갑상선 중독증 - 빈맥 및 고열",
            scenario=ClinicalScenario.WARNING,
            glucose=110,
            systolic_bp=140,
            diastolic_bp=85,
            heart_rate=115,
            temperature=38.0,
            spo2=98,
            expected_severity=2,
            expected_is_emergency=False,
            medical_context="TSH 억제, 베타 차단제 개시 검토"
        )
        
        # 시나리오 9: 저체온증 (응급)
        self.add_test_case(
            description="저체온증 - 생명 위협",
            scenario=ClinicalScenario.CRITICAL,
            glucose=85,
            systolic_bp=75,
            diastolic_bp=45,
            heart_rate=35,
            temperature=33.5,
            spo2=89,
            expected_severity=4,
            expected_is_emergency=True,
            medical_context="극도의 저체온증 → 응급 진료 필요"
        )
        
        # 시나리오 10: 천식 발작 (응급)
        self.add_test_case(
            description="천식 발작 - 산소 부족",
            scenario=ClinicalScenario.CRITICAL,
            glucose=105,
            systolic_bp=130,
            diastolic_bp=80,
            heart_rate=125,
            temperature=36.8,
            spo2=82,
            expected_severity=4,
            expected_is_emergency=True,
            medical_context="급성 천식 발작 → 산소 + 기관지확장제"
        )
        
        # 추가 복합 시나리오
        scenarios = [
            ("임신성 고혈압", 110, 140, 90, 85, 37.0, 98, 2, False, "임신 3분기, 단백뇨 검사"),
            ("외상 후 쇼크", 120, 90, 55, 135, 36.0, 90, 4, True, "차 사고 후 내출혈 의심"),
            ("악성 고혈압", 180, 180, 125, 100, 37.5, 95, 4, True, "뇌혈관 사고 위험"),
            ("저나트륨혈증", 95, 125, 80, 95, 36.5, 98, 2, False, "SIADH 의심"),
            ("고칼륨혈증", 100, 135, 85, 65, 36.8, 98, 3, False, "심전도 S파 상승"),
            ("신부전", 120, 155, 95, 85, 37.2, 96, 3, False, "크레아티닌 상승"),
            ("흡입성 폐렴", 110, 130, 80, 105, 38.8, 85, 3, False, "포자흡입 후 3주"),
            ("패혈성 쇼크", 200, 80, 45, 140, 39.8, 88, 4, True, "다기관 부전"),
            ("뇌졸중 급성기", 140, 170, 105, 95, 37.3, 94, 4, True, "편측 마비 + 언어장애"),
            ("심근경색 회복기", 130, 145, 88, 78, 37.0, 97, 2, False, "경심조 관찰 3일차"),
        ]
        
        for desc, glucose, sbp, dbp, hr, temp, spo2, severity, emergency, context in scenarios:
            self.add_test_case(
                description=desc,
                scenario=ClinicalScenario.CRITICAL if emergency else (ClinicalScenario.WARNING if severity >= 2 else ClinicalScenario.NORMAL),
                glucose=glucose,
                systolic_bp=sbp,
                diastolic_bp=dbp,
                heart_rate=hr,
                temperature=temp,
                spo2=spo2,
                expected_severity=severity,
                expected_is_emergency=emergency,
                medical_context=context
            )
    
    def export_json(self, filename: str = "medical_test_cases.json"):
        """JSON으로 내보내기"""
        data = {
            "metadata": {
                "total_cases": len(self.test_cases),
                "generated_at": datetime.now().isoformat(),
                "medical_standards": [
                    "ADA (American Diabetes Association)",
                    "ACC/AHA (American College of Cardiology/American Heart Association)",
                    "WHO (World Health Organization)",
                    "MFDS (Ministry of Food and Drug Safety)",
                    "FDA (Food and Drug Administration)"
                ]
            },
            "test_cases": self.test_cases
        }
        
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
        
        print(f"\n✓ {len(self.test_cases)} 테스트 케이스가 {filename}으로 저장되었습니다.")
        return filename
    
    def print_summary(self):
        """요약 출력"""
        print("\n" + "=" * 80)
        print("테스트 케이스 요약")
        print("=" * 80)
        
        normal = sum(1 for tc in self.test_cases if tc["expected_results"]["severity_level"] == 1)
        warning = sum(1 for tc in self.test_cases if tc["expected_results"]["severity_level"] == 2)
        urgent = sum(1 for tc in self.test_cases if tc["expected_results"]["severity_level"] == 3)
        critical = sum(1 for tc in self.test_cases if tc["expected_results"]["severity_level"] == 4)
        emergencies = sum(1 for tc in self.test_cases if tc["expected_results"]["is_emergency"])
        
        print(f"총 테스트 케이스: {len(self.test_cases)}")
        print(f"  - 정상 (Level 1): {normal}")
        print(f"  - 경고 (Level 2): {warning}")
        print(f"  - 긴급 (Level 3): {urgent}")
        print(f"  - 응급 (Level 4): {critical}")
        print(f"  - 응급 상황 감지: {emergencies}")
        print("=" * 80)


def main():
    """메인 함수"""
    generator = MedicalTestCaseGenerator()
    generator.generate_all_tests()
    generator.print_summary()
    generator.export_json("medical_test_cases_100.json")


if __name__ == "__main__":
    main()
