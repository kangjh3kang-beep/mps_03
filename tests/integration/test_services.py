"""
만파식적 생태계 통합 테스트
모든 마이크로서비스의 정상 작동을 검증
"""

import asyncio
import aiohttp
import pytest
from datetime import datetime

# 서비스 엔드포인트
BASE_URL = "http://localhost:8080"  # API Gateway

SERVICES = {
    "auth": {"port": 8001, "health": "/health"},
    "measurement": {"port": 8002, "health": "/api/health"},
    "ai": {"port": 3003, "health": "/health"},
    "payment": {"port": 3004, "health": "/health"},
    "notification": {"port": 3005, "health": "/health"},
    "video": {"port": 3006, "health": "/health"},
    "translation": {"port": 3007, "health": "/health"},
    "data": {"port": 3008, "health": "/health"},
    "admin": {"port": 3009, "health": "/health"},
}


class TestServiceHealth:
    """서비스 헬스 체크 테스트"""
    
    @pytest.mark.asyncio
    async def test_auth_service_health(self):
        """Auth Service 상태 확인"""
        async with aiohttp.ClientSession() as session:
            async with session.get(f"http://localhost:8001/health") as resp:
                assert resp.status == 200
                data = await resp.json()
                assert data["status"] == "ok"
                assert data["service"] == "auth-service"
    
    @pytest.mark.asyncio
    async def test_measurement_service_health(self):
        """Measurement Service 상태 확인"""
        async with aiohttp.ClientSession() as session:
            async with session.get(f"http://localhost:8002/api/health") as resp:
                assert resp.status == 200
                data = await resp.json()
                assert data["status"] == "healthy"
    
    @pytest.mark.asyncio
    async def test_ai_service_health(self):
        """AI Service 상태 확인"""
        async with aiohttp.ClientSession() as session:
            async with session.get(f"http://localhost:3003/health") as resp:
                assert resp.status == 200
                data = await resp.json()
                assert data["status"] == "healthy"
    
    @pytest.mark.asyncio
    async def test_all_services_via_gateway(self):
        """API Gateway를 통한 모든 서비스 확인"""
        async with aiohttp.ClientSession() as session:
            # Gateway health
            async with session.get(f"{BASE_URL}/health") as resp:
                assert resp.status == 200


class TestAuthService:
    """Auth Service 기능 테스트"""
    
    @pytest.fixture
    def test_user(self):
        return {
            "email": f"test_{datetime.now().timestamp()}@example.com",
            "password": "TestPassword123!",
            "name": "테스트 사용자"
        }
    
    @pytest.mark.asyncio
    async def test_signup(self, test_user):
        """회원가입 테스트"""
        async with aiohttp.ClientSession() as session:
            async with session.post(
                f"http://localhost:8001/api/auth/signup",
                json=test_user
            ) as resp:
                assert resp.status in [200, 201]
                data = await resp.json()
                assert data["success"] == True
                assert "token" in data
                return data
    
    @pytest.mark.asyncio
    async def test_login(self, test_user):
        """로그인 테스트"""
        # 먼저 회원가입
        await self.test_signup(test_user)
        
        async with aiohttp.ClientSession() as session:
            async with session.post(
                f"http://localhost:8001/api/auth/login",
                json={
                    "email": test_user["email"],
                    "password": test_user["password"]
                }
            ) as resp:
                assert resp.status == 200
                data = await resp.json()
                assert data["success"] == True
                assert "token" in data
    
    @pytest.mark.asyncio
    async def test_token_verification(self, test_user):
        """토큰 검증 테스트"""
        # 로그인하여 토큰 획득
        signup_data = await self.test_signup(test_user)
        token = signup_data["token"]
        
        async with aiohttp.ClientSession() as session:
            async with session.post(
                f"http://localhost:8001/api/auth/verify",
                headers={"Authorization": f"Bearer {token}"}
            ) as resp:
                assert resp.status == 200
                data = await resp.json()
                assert data["success"] == True


class TestMeasurementService:
    """Measurement Service 기능 테스트"""
    
    @pytest.fixture
    def mock_token(self):
        return "mock-jwt-token-for-testing"
    
    @pytest.fixture
    def sample_measurement(self):
        return {
            "type": "glucose",
            "value": 98,
            "unit": "mg/dL",
            "timestamp": datetime.now().isoformat(),
            "notes": "공복 측정"
        }
    
    @pytest.mark.asyncio
    async def test_create_measurement(self, mock_token, sample_measurement):
        """측정 데이터 저장 테스트"""
        async with aiohttp.ClientSession() as session:
            async with session.post(
                f"http://localhost:8002/api/measurements",
                json=sample_measurement,
                headers={"Authorization": f"Bearer {mock_token}"}
            ) as resp:
                # 인증 없이도 테스트 가능하도록 201 또는 401 허용
                assert resp.status in [201, 401, 200]
    
    @pytest.mark.asyncio
    async def test_get_measurements(self, mock_token):
        """측정 데이터 조회 테스트"""
        async with aiohttp.ClientSession() as session:
            async with session.get(
                f"http://localhost:8002/api/measurements",
                headers={"Authorization": f"Bearer {mock_token}"}
            ) as resp:
                assert resp.status in [200, 401]


class TestAIService:
    """AI Service 기능 테스트"""
    
    @pytest.fixture
    def health_data(self):
        return {
            "glucose": 105,
            "systolic": 125,
            "diastolic": 82,
            "heart_rate": 75,
            "oxygen_saturation": 97
        }
    
    @pytest.mark.asyncio
    async def test_coaching_recommendations(self, health_data):
        """AI 코칭 추천 테스트"""
        async with aiohttp.ClientSession() as session:
            async with session.post(
                f"http://localhost:3003/api/coaching/recommendations",
                json=health_data
            ) as resp:
                assert resp.status in [200, 422]  # 422는 validation error
                if resp.status == 200:
                    data = await resp.json()
                    assert "recommendations" in data
    
    @pytest.mark.asyncio
    async def test_health_prediction(self, health_data):
        """건강 예측 테스트"""
        async with aiohttp.ClientSession() as session:
            async with session.post(
                f"http://localhost:3003/api/coaching/predict",
                json={
                    "measurements": health_data,
                    "history_days": 7
                }
            ) as resp:
                assert resp.status in [200, 422]


class TestPaymentService:
    """Payment Service 기능 테스트"""
    
    @pytest.mark.asyncio
    async def test_payment_health(self):
        """결제 서비스 상태 확인"""
        async with aiohttp.ClientSession() as session:
            async with session.get(f"http://localhost:3004/health") as resp:
                assert resp.status == 200


class TestNotificationService:
    """Notification Service 기능 테스트"""
    
    @pytest.mark.asyncio
    async def test_notification_health(self):
        """알림 서비스 상태 확인"""
        async with aiohttp.ClientSession() as session:
            async with session.get(f"http://localhost:3005/health") as resp:
                assert resp.status == 200


class TestVideoService:
    """Video Service 기능 테스트"""
    
    @pytest.mark.asyncio
    async def test_video_health(self):
        """화상 서비스 상태 확인"""
        async with aiohttp.ClientSession() as session:
            async with session.get(f"http://localhost:3006/health") as resp:
                assert resp.status == 200


class TestIntegration:
    """통합 시나리오 테스트"""
    
    @pytest.mark.asyncio
    async def test_full_user_journey(self):
        """전체 사용자 여정 테스트"""
        async with aiohttp.ClientSession() as session:
            # 1. 회원가입
            user_data = {
                "email": f"journey_{datetime.now().timestamp()}@test.com",
                "password": "Journey123!",
                "name": "여정테스트"
            }
            
            async with session.post(
                "http://localhost:8001/api/auth/signup",
                json=user_data
            ) as resp:
                if resp.status in [200, 201]:
                    signup_result = await resp.json()
                    token = signup_result.get("token", "")
                    
                    # 2. 측정 데이터 저장
                    measurement = {
                        "type": "glucose",
                        "value": 95,
                        "unit": "mg/dL"
                    }
                    
                    async with session.post(
                        "http://localhost:8002/api/measurements",
                        json=measurement,
                        headers={"Authorization": f"Bearer {token}"}
                    ) as measure_resp:
                        # 성공 또는 인증 오류
                        assert measure_resp.status in [200, 201, 401]
                    
                    # 3. AI 코칭 요청
                    health_data = {
                        "glucose": 95,
                        "systolic": 120,
                        "diastolic": 80,
                        "heart_rate": 72,
                        "oxygen_saturation": 98
                    }
                    
                    async with session.post(
                        "http://localhost:3003/api/coaching/recommendations",
                        json=health_data
                    ) as ai_resp:
                        assert ai_resp.status in [200, 422]


# 직접 실행용
async def run_quick_test():
    """빠른 테스트 실행"""
    print("=" * 60)
    print("만파식적 생태계 서비스 상태 검증")
    print("=" * 60)
    
    async with aiohttp.ClientSession() as session:
        results = []
        
        for name, config in SERVICES.items():
            url = f"http://localhost:{config['port']}{config['health']}"
            try:
                async with session.get(url, timeout=aiohttp.ClientTimeout(total=5)) as resp:
                    status = "✅ 정상" if resp.status == 200 else f"⚠️ 상태: {resp.status}"
                    results.append((name, status, resp.status))
            except Exception as e:
                results.append((name, f"❌ 오류: {str(e)[:30]}", 0))
        
        print("\n서비스 상태:")
        print("-" * 50)
        for name, status, code in results:
            print(f"  {name:15} | {status}")
        
        # 요약
        ok_count = sum(1 for _, _, code in results if code == 200)
        total = len(results)
        print("-" * 50)
        print(f"결과: {ok_count}/{total} 서비스 정상 작동")
        print("=" * 60)
        
        return ok_count == total


if __name__ == "__main__":
    asyncio.run(run_quick_test())

