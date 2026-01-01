import unittest
import json
from main import app, generate_hash_chain
from fastapi.testclient import TestClient

client = TestClient(app)

class TestMPSIntegration(unittest.TestCase):
    def test_health_check_and_self_healing(self):
        """자가치유 엔진 작동 테스트"""
        response = client.get("/ai/health-check")
        self.assertEqual(response.status_code, 200)
        self.assertTrue(response.json()["self_healing_active"])

    def test_external_data_verification_success(self):
        """외부 데이터 신뢰성 검증 성공 시나리오"""
        payload = {
            "source": "apple_health",
            "signature": "valid_signature_token_long_enough",
            "data": {"heart_rate": 75, "steps": 10000}
        }
        response = client.post("/ai/integrate-external-data", json=payload)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json()["status"], "Integrated")
        self.assertIn("data_integrity_token", response.json())

    def test_external_data_verification_failure(self):
        """외부 데이터 신뢰성 검증 실패 시나리오 (잘못된 서명)"""
        payload = {
            "source": "unknown_source",
            "signature": "short",
            "data": {"heart_rate": 75}
        }
        response = client.post("/ai/integrate-external-data", json=payload)
        self.assertEqual(response.json()["status"], "Failed")

    def test_hash_chain_integrity(self):
        """해시 체인 무결성 테스트"""
        data1 = {"val": 1}
        hash1 = generate_hash_chain(data1)
        data2 = {"val": 2}
        hash2 = generate_hash_chain(data2)
        self.assertNotEqual(hash1, hash2)

if __name__ == "__main__":
    unittest.main()
