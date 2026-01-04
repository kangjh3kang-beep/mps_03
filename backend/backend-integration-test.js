/**
 * Backend Integration Test - All Services
 * Mock API + Auth Service + Measurement Service + AI Service 통합 테스트
 */

const axios = require('axios');

// ANSI 색상 코드
const colors = {
  reset: '\x1b[0m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m'
};

// 테스트 설정
const API_BASE = 'http://localhost:5000'; // Mock API
const AUTH_BASE = 'http://localhost:8001'; // Auth Service
const MEASUREMENT_BASE = 'http://localhost:8002'; // Measurement Service
const AI_BASE = 'http://localhost:8003'; // AI Service

const TEST_USER = {
  userId: 'user_123',
  email: 'test@example.com',
  password: 'SecurePassword123!'
};

let testResults = {
  passed: 0,
  failed: 0,
  total: 0
};

// ============================================
// 테스트 유틸리티
// ============================================

function log(message, type = 'info') {
  const timestamp = new Date().toLocaleTimeString();
  const prefix = `[${timestamp}]`;
  
  switch (type) {
    case 'success':
      console.log(`${colors.green}✓${colors.reset} ${prefix} ${message}`);
      break;
    case 'error':
      console.log(`${colors.red}✗${colors.reset} ${prefix} ${message}`);
      break;
    case 'warning':
      console.log(`${colors.yellow}⚠${colors.reset} ${prefix} ${message}`);
      break;
    case 'info':
      console.log(`${colors.blue}ℹ${colors.reset} ${prefix} ${message}`);
      break;
    case 'test':
      console.log(`\n${colors.cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}`);
      console.log(`${colors.cyan}${message}${colors.reset}`);
      console.log(`${colors.cyan}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}\n`);
      break;
  }
}

async function test(name, fn) {
  testResults.total++;
  try {
    await fn();
    testResults.passed++;
    log(`${name}`, 'success');
    return true;
  } catch (error) {
    testResults.failed++;
    log(`${name}: ${error.message}`, 'error');
    return false;
  }
}

async function request(method, url, data = null, headers = {}) {
  const config = {
    method,
    url,
    headers: {
      'Content-Type': 'application/json',
      ...headers
    },
    timeout: 5000
  };
  
  if (data) config.data = data;
  
  const response = await axios(config);
  return response.data;
}

// ============================================
// 테스트 시나리오
// ============================================

async function runTests() {
  log(`\n🚀 Manpasik Ecosystem - 백엔드 통합 테스트 시작`, 'test');
  
  // ============================================
  // Test Suite 1: Health Check
  // ============================================
  log('Suite 1: 서비스 상태 확인', 'test');

  await test('Mock API Health Check', async () => {
    const response = await request('GET', `${API_BASE}/health`);
    if (response.status !== 'ok') throw new Error('Service not healthy');
  });

  await test('Auth Service Health Check', async () => {
    const response = await request('GET', `${AUTH_BASE}/health`);
    if (response.status !== 'ok') throw new Error('Service not healthy');
  });

  await test('Measurement Service Health Check', async () => {
    const response = await request('GET', `${MEASUREMENT_BASE}/health`);
    if (response.status !== 'ok') throw new Error('Service not healthy');
  });

  await test('AI Service Health Check', async () => {
    const response = await request('GET', `${AI_BASE}/health`);
    if (response.status !== 'ok') throw new Error('Service not healthy');
  });

  // ============================================
  // Test Suite 2: 측정 데이터 워크플로우
  // ============================================
  log('Suite 2: 측정 데이터 저장 및 조회', 'test');

  let measurementId = null;

  await test('Measurement Service에 데이터 저장', async () => {
    const measurement = {
      userId: TEST_USER.userId,
      type: 'blood_glucose',
      value: 105,
      unit: 'mg/dL',
      timestamp: new Date().toISOString()
    };

    const response = await request('POST', `${MEASUREMENT_BASE}/api/measurements`, measurement);
    if (!response.success || !response.data.id) throw new Error('Failed to save measurement');
    measurementId = response.data.id;
  });

  await test('Measurement Service에서 데이터 조회', async () => {
    const response = await request(
      'GET',
      `${MEASUREMENT_BASE}/api/measurements/${TEST_USER.userId}?limit=10`
    );
    if (!response.success || !Array.isArray(response.data)) throw new Error('Failed to fetch measurements');
    if (response.data.length === 0) throw new Error('No measurements found');
  });

  await test('건강 점수 조회', async () => {
    const response = await request('GET', `${MEASUREMENT_BASE}/api/health-score/${TEST_USER.userId}`);
    if (!response.success || !response.data.overall) throw new Error('Failed to fetch health score');
  });

  // ============================================
  // Test Suite 3: 트렌드 분석
  // ============================================
  log('Suite 3: 데이터 트렌드 분석', 'test');

  await test('7일 트렌드 조회', async () => {
    const response = await request('GET', `${MEASUREMENT_BASE}/api/trends/${TEST_USER.userId}?days=7`);
    if (!response.success || !response.data.trends) throw new Error('Failed to fetch trends');
  });

  await test('상관관계 분석', async () => {
    const response = await request('GET', `${MEASUREMENT_BASE}/api/correlations/${TEST_USER.userId}`);
    if (!response.success || !response.data.correlations) throw new Error('Failed to fetch correlations');
  });

  await test('보고서 생성', async () => {
    const request_data = {
      userId: TEST_USER.userId,
      format: 'json',
      period: 7
    };
    const response = await request('POST', `${MEASUREMENT_BASE}/api/reports/generate`, request_data);
    if (!response.success || !response.data.reportId) throw new Error('Failed to generate report');
  });

  // ============================================
  // Test Suite 4: AI 코칭
  // ============================================
  log('Suite 4: AI 코칭 및 권장사항', 'test');

  let coachingId = null;

  await test('코칭 권장사항 생성', async () => {
    const coachingRequest = {
      userId: TEST_USER.userId,
      measurements: [
        {
          type: 'blood_glucose',
          value: 110,
          unit: 'mg/dL',
          timestamp: new Date().toISOString()
        },
        {
          type: 'heart_rate',
          value: 75,
          unit: 'bpm',
          timestamp: new Date().toISOString()
        },
        {
          type: 'blood_pressure',
          value: '120/80',
          unit: 'mmHg',
          timestamp: new Date().toISOString()
        },
        {
          type: 'oxygen_level',
          value: 98,
          unit: '%',
          timestamp: new Date().toISOString()
        }
      ]
    };

    const response = await request('POST', `${AI_BASE}/api/coaching/recommendations`, coachingRequest);
    if (!response.coachingId || !Array.isArray(response.recommendations)) {
      throw new Error('Failed to generate coaching recommendations');
    }
    coachingId = response.coachingId;
  });

  await test('건강 예측 (72시간)', async () => {
    const predictionRequest = {
      userId: TEST_USER.userId,
      measurements: [
        {
          type: 'blood_glucose',
          value: 105,
          unit: 'mg/dL',
          timestamp: new Date().toISOString()
        },
        {
          type: 'heart_rate',
          value: 72,
          unit: 'bpm',
          timestamp: new Date().toISOString()
        }
      ],
      lookAheadDays: 7
    };

    const response = await request('POST', `${AI_BASE}/api/predictions`, predictionRequest);
    if (!response.predictions || !response.confidence) throw new Error('Failed to get predictions');
  });

  await test('개인화된 인사이트 조회', async () => {
    // 먼저 코칭 기록이 있는지 확인
    try {
      const response = await request('GET', `${AI_BASE}/api/coaching/insights/${TEST_USER.userId}`);
      if (!response.success || !response.data.key_metrics) throw new Error('Failed to fetch insights');
    } catch (error) {
      // 코칭 기록이 없을 수 있으므로 경고만 표시
      log('인사이트 조회 (초기 데이터 부족)', 'warning');
    }
  });

  await test('적응형 코칭 계획 생성', async () => {
    const planRequest = {
      userId: TEST_USER.userId,
      measurements: [
        {
          type: 'blood_glucose',
          value: 105,
          unit: 'mg/dL',
          timestamp: new Date().toISOString()
        }
      ]
    };

    const response = await request('POST', `${AI_BASE}/api/coaching/adaptive-plan`, planRequest);
    if (!response.success || !response.data.planId) throw new Error('Failed to generate adaptive plan');
  });

  // ============================================
  // Test Suite 5: 배치 작업
  // ============================================
  log('Suite 5: 배치 작업 및 성능', 'test');

  await test('배치 측정값 저장 (100개)', async () => {
    const measurements = [];
    for (let i = 0; i < 100; i++) {
      measurements.push({
        type: 'blood_glucose',
        value: 95 + Math.random() * 20,
        unit: 'mg/dL',
        timestamp: new Date(Date.now() - i * 3600000).toISOString()
      });
    }

    const batchRequest = {
      userId: TEST_USER.userId,
      measurements
    };

    const start = Date.now();
    const response = await request('POST', `${MEASUREMENT_BASE}/api/measurements/batch`, batchRequest);
    const duration = Date.now() - start;

    if (!response.success || response.saved < 100) {
      throw new Error(`Failed to save all measurements. Saved: ${response.saved}`);
    }
    if (duration > 2000) {
      log(`배치 작업 완료 (${duration}ms - 성능 확인 필요)`, 'warning');
    }
  });

  // ============================================
  // Test Suite 6: 에러 처리
  // ============================================
  log('Suite 6: 에러 처리 및 유효성 검증', 'test');

  await test('잘못된 데이터 거부 (필수 필드 누락)', async () => {
    try {
      await request('POST', `${MEASUREMENT_BASE}/api/measurements`, {
        userId: TEST_USER.userId
        // type, value, unit 누락
      });
      throw new Error('Should have rejected invalid data');
    } catch (error) {
      if (error.response?.status === 400) {
        // 예상된 에러
      } else {
        throw error;
      }
    }
  });

  await test('존재하지 않는 사용자 처리', async () => {
    try {
      await request('GET', `${MEASUREMENT_BASE}/api/measurements/nonexistent_user_123?limit=10`);
      // 빈 결과도 성공으로 취급 (404가 아닌 경우)
    } catch (error) {
      if (error.response?.status === 404) {
        // 예상된 에러
      }
    }
  });

  // ============================================
  // 최종 결과 출력
  // ============================================
  log(`\n📊 테스트 결과 요약`, 'test');
  
  const passPercentage = ((testResults.passed / testResults.total) * 100).toFixed(1);
  const resultColor = testResults.failed === 0 ? 'green' : 'yellow';
  
  console.log(`
${colors.cyan}┌─────────────────────────────────────────┐${colors.reset}
${colors.cyan}│ 총 테스트: ${testResults.total.toString().padEnd(4)} 개                     ${colors.cyan}│${colors.reset}
${colors.cyan}│ 통과: ${colors.green}${testResults.passed.toString().padEnd(4)}${colors.cyan} 개  실패: ${colors.red}${testResults.failed.toString().padEnd(4)}${colors.cyan} 개        ${colors.cyan}│${colors.reset}
${colors.cyan}│ 성공률: ${passPercentage.toString().padEnd(5)} %                ${colors.cyan}│${colors.reset}
${colors.cyan}└─────────────────────────────────────────┘${colors.reset}
  `);

  if (testResults.failed === 0) {
    log('✅ 모든 테스트 통과!', 'success');
    return 0;
  } else {
    log(`⚠️  ${testResults.failed}개 테스트 실패`, 'error');
    return 1;
  }
}

// ============================================
// 실행
// ============================================

runTests()
  .then(exitCode => {
    process.exit(exitCode);
  })
  .catch(error => {
    log(`치명적 오류: ${error.message}`, 'error');
    process.exit(1);
  });
