#!/usr/bin/env python3
"""
MPS Healthcare System - Phase 1 Week 1 통합 테스트 스위트
Version: 1.0
Created: 2026-01-02

모든 마이크로서비스의 통합 테스트 및 검증
"""

import sys
import json
import time
import subprocess
from datetime import datetime
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent / "backend/services/ai-service"))

from medical_coach import (
    MedicalExpertBackedCoach,
    VitalSigns,
    SeverityLevel,
)


class TestResult:
    """테스트 결과"""
    def __init__(self, name: str):
        self.name = name
        self.passed = 0
        self.failed = 0
        self.errors = []
        self.start_time = None
        self.end_time = None

    def start(self):
        self.start_time = time.time()

    def end(self):
        self.end_time = time.time()

    def duration(self) -> float:
        if self.start_time and self.end_time:
            return self.end_time - self.start_time
        return 0

    def pass_test(self):
        self.passed += 1

    def fail_test(self, error: str):
        self.failed += 1
        self.errors.append(error)

    def summary(self) -> dict:
        return {
            "test_suite": self.name,
            "passed": self.passed,
            "failed": self.failed,
            "total": self.passed + self.failed,
            "duration_seconds": round(self.duration(), 2),
            "errors": self.errors if self.errors else None,
        }


class MedicalTestSuite(TestResult):
    """의료 신호 테스트 스위트"""

    def __init__(self):
        super().__init__("Medical Signal Tests")
        self.coach = MedicalExpertBackedCoach("test_patient_001")

    def test_normal_glucose(self):
        """정상 혈당 테스트"""
        result = self.coach.assess_glucose(100)
        if (
            result.severity_level == SeverityLevel.LEVEL_1_NORMAL
            and result.confidence > 0.9
        ):
            self.pass_test()
            return True
        else:
            self.fail_test(
                f"Expected NORMAL glucose, got {result.severity_level} (confidence: {result.confidence})"
            )
            return False

    def test_critical_low_glucose(self):
        """심각한 저혈당 테스트"""
        result = self.coach.assess_glucose(35)
        if (
            result.severity_level == SeverityLevel.LEVEL_4_CRITICAL
            and result.is_emergency
        ):
            self.pass_test()
            return True
        else:
            self.fail_test(
                f"Expected CRITICAL low glucose, got {result.severity_level}"
            )
            return False

    def test_critical_high_glucose(self):
        """심각한 고혈당 테스트"""
        result = self.coach.assess_glucose(380)
        if (
            result.severity_level == SeverityLevel.LEVEL_4_CRITICAL
            and result.is_emergency
        ):
            self.pass_test()
            return True
        else:
            self.fail_test(
                f"Expected CRITICAL high glucose, got {result.severity_level}"
            )
            return False

    def test_normal_blood_pressure(self):
        """정상 혈압 테스트"""
        result = self.coach.assess_blood_pressure(115, 75)
        if result.severity_level == SeverityLevel.LEVEL_1_NORMAL:
            self.pass_test()
            return True
        else:
            self.fail_test(
                f"Expected NORMAL blood pressure, got {result.severity_level}"
            )
            return False

    def test_critical_blood_pressure(self):
        """위기 혈압 테스트"""
        result = self.coach.assess_blood_pressure(185, 125)
        if (
            result.severity_level == SeverityLevel.LEVEL_4_CRITICAL
            and result.is_emergency
        ):
            self.pass_test()
            return True
        else:
            self.fail_test(
                f"Expected CRITICAL blood pressure, got {result.severity_level}"
            )
            return False

    def test_normal_heart_rate(self):
        """정상 심박수 테스트"""
        result = self.coach.assess_heart_rate(72)
        if result.severity_level == SeverityLevel.LEVEL_1_NORMAL:
            self.pass_test()
            return True
        else:
            self.fail_test(
                f"Expected NORMAL heart rate, got {result.severity_level}"
            )
            return False

    def test_critical_heart_rate(self):
        """위기 심박수 테스트"""
        result = self.coach.assess_heart_rate(155)
        if (
            result.severity_level == SeverityLevel.LEVEL_4_CRITICAL
            and result.is_emergency
        ):
            self.pass_test()
            return True
        else:
            self.fail_test(
                f"Expected CRITICAL heart rate, got {result.severity_level}"
            )
            return False

    def test_normal_temperature(self):
        """정상 체온 테스트"""
        result = self.coach.assess_temperature(37.0)
        if result.severity_level == SeverityLevel.LEVEL_1_NORMAL:
            self.pass_test()
            return True
        else:
            self.fail_test(
                f"Expected NORMAL temperature, got {result.severity_level}"
            )
            return False

    def test_critical_temperature(self):
        """위기 체온 테스트"""
        result = self.coach.assess_temperature(40.5)
        if (
            result.severity_level == SeverityLevel.LEVEL_4_CRITICAL
            and result.is_emergency
        ):
            self.pass_test()
            return True
        else:
            self.fail_test(
                f"Expected CRITICAL temperature, got {result.severity_level}"
            )
            return False

    def run_all(self):
        """모든 테스트 실행"""
        self.start()
        print("\n" + "=" * 60)
        print("의료 신호 검증 테스트 시작")
        print("=" * 60)

        tests = [
            ("정상 혈당 (100 mg/dL)", self.test_normal_glucose),
            ("심각한 저혈당 (35 mg/dL)", self.test_critical_low_glucose),
            ("심각한 고혈당 (380 mg/dL)", self.test_critical_high_glucose),
            ("정상 혈압 (120/80)", self.test_normal_blood_pressure),
            ("위기 혈압 (185/125)", self.test_critical_blood_pressure),
            ("정상 심박수 (72 bpm)", self.test_normal_heart_rate),
            ("위기 심박수 (155 bpm)", self.test_critical_heart_rate),
            ("정상 체온 (37°C)", self.test_normal_temperature),
            ("위기 체온 (40.5°C)", self.test_critical_temperature),
        ]

        for test_name, test_func in tests:
            try:
                result = test_func()
                status = "✓ PASS" if result else "✗ FAIL"
                print(f"{status}: {test_name}")
            except Exception as e:
                self.fail_test(f"{test_name}: {str(e)}")
                print(f"✗ ERROR: {test_name} - {str(e)}")

        self.end()
        return self.summary()


class ComprehensiveAssessmentTestSuite(TestResult):
    """종합 평가 테스트 스위트"""

    def __init__(self):
        super().__init__("Comprehensive Assessment Tests")
        self.coach = MedicalExpertBackedCoach("patient_comprehensive")

    def test_normal_patient(self):
        """정상 환자 종합 평가"""
        vitals = VitalSigns(
            glucose_mg_dl=100,
            systolic_bp=115,
            diastolic_bp=75,
            heart_rate_bpm=72,
            temperature_celsius=37.0,
            spo2_percent=98,
        )

        result = self.coach.comprehensive_assessment(vitals)
        if result["overall_severity"] == 1 and not result["is_emergency"]:
            self.pass_test()
            return True
        else:
            self.fail_test(f"Expected normal patient, got severity {result['overall_severity']}")
            return False

    def test_emergency_patient(self):
        """응급 환자 감지"""
        vitals = VitalSigns(
            glucose_mg_dl=45,
            systolic_bp=185,
            diastolic_bp=125,
            heart_rate_bpm=155,
            temperature_celsius=40.5,
            spo2_percent=85,
        )

        result = self.coach.comprehensive_assessment(vitals)
        if result.get("is_emergency") and len(result["risk_factors"]) > 0:
            self.pass_test()
            return True
        else:
            self.fail_test(f"Failed to detect emergency patient")
            return False

    def test_emergency_detection_accuracy(self):
        """응급 감지 정확도"""
        vitals = VitalSigns(
            glucose_mg_dl=35,
            systolic_bp=110,
            diastolic_bp=70,
            heart_rate_bpm=85,
            temperature_celsius=36.8,
            spo2_percent=98,
        )

        is_emergency, reasons, action = self.coach.emergency_detection(vitals)
        if is_emergency and "저혈당" in reasons[0]:
            self.pass_test()
            return True
        else:
            self.fail_test("Failed to detect hypoglycemia emergency")
            return False

    def run_all(self):
        """모든 테스트 실행"""
        self.start()
        print("\n" + "=" * 60)
        print("종합 평가 검증 테스트 시작")
        print("=" * 60)

        tests = [
            ("정상 환자 종합 평가", self.test_normal_patient),
            ("응급 환자 감지", self.test_emergency_patient),
            ("응급 감지 정확도", self.test_emergency_detection_accuracy),
        ]

        for test_name, test_func in tests:
            try:
                result = test_func()
                status = "✓ PASS" if result else "✗ FAIL"
                print(f"{status}: {test_name}")
            except Exception as e:
                self.fail_test(f"{test_name}: {str(e)}")
                print(f"✗ ERROR: {test_name} - {str(e)}")

        self.end()
        return self.summary()


class IntegrationTestRunner:
    """통합 테스트 러너"""

    def __init__(self):
        self.results = []
        self.start_time = datetime.now()

    def run_all_tests(self):
        """모든 테스트 스위트 실행"""
        print("\n" + "=" * 80)
        print("MPS Healthcare System - Phase 1 Week 1 통합 테스트")
        print("=" * 80)
        print(f"시작 시간: {self.start_time.strftime('%Y-%m-%d %H:%M:%S')}")

        # 의료 신호 테스트
        medical_tests = MedicalTestSuite()
        self.results.append(medical_tests.run_all())

        # 종합 평가 테스트
        comprehensive_tests = ComprehensiveAssessmentTestSuite()
        self.results.append(comprehensive_tests.run_all())

        # 결과 출력
        self.print_summary()

    def print_summary(self):
        """결과 요약 출력"""
        print("\n" + "=" * 80)
        print("테스트 결과 요약")
        print("=" * 80)

        total_passed = 0
        total_failed = 0
        total_duration = 0

        for result in self.results:
            total_passed += result["passed"]
            total_failed += result["failed"]
            total_duration += result["duration_seconds"]

            status = "✓" if result["failed"] == 0 else "✗"
            print(
                f"{status} {result['test_suite']}: "
                f"{result['passed']}/{result['total']} passed "
                f"({result['duration_seconds']}s)"
            )

            if result["errors"]:
                for error in result["errors"]:
                    print(f"   - {error}")

        print("\n" + "-" * 80)
        print(f"총 테스트: {total_passed + total_failed}")
        print(f"통과: {total_passed}")
        print(f"실패: {total_failed}")
        print(f"총 소요 시간: {total_duration:.2f}초")
        print(f"성공률: {(total_passed / (total_passed + total_failed) * 100):.1f}%")

        end_time = datetime.now()
        print(f"종료 시간: {end_time.strftime('%Y-%m-%d %H:%M:%S')}")

        # JSON 보고서 저장
        report = {
            "timestamp": self.start_time.isoformat(),
            "test_results": self.results,
            "summary": {
                "total_tests": total_passed + total_failed,
                "passed": total_passed,
                "failed": total_failed,
                "success_rate": round(total_passed / (total_passed + total_failed) * 100, 1),
                "total_duration_seconds": round(total_duration, 2),
            },
        }

        report_path = Path(__file__).parent / "integration_test_report.json"
        with open(report_path, "w", encoding="utf-8") as f:
            json.dump(report, f, indent=2, ensure_ascii=False)

        print(f"\n✓ 테스트 보고서 저장: {report_path}")
        print("=" * 80)

        # 최종 결과
        if total_failed == 0:
            print("\n🎉 모든 테스트 통과!")
            return 0
        else:
            print(f"\n⚠️  {total_failed}개 테스트 실패")
            return 1


def main():
    """메인 함수"""
    runner = IntegrationTestRunner()
    runner.run_all_tests()
    
    # Exit code 반환
    return 0 if all(r["failed"] == 0 for r in runner.results) else 1


if __name__ == "__main__":
    sys.exit(main())
