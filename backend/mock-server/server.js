const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { v4: uuidv4 } = require('uuid');
const { addDays, subDays, format } = require('date-fns');
const _ = require('lodash');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// 로깅 미들웨어
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
  next();
});

// ===== Mock 데이터베이스 =====
const mockDB = {
  users: {
    'user_123': {
      id: 'user_123',
      email: 'user@example.com',
      name: '테스트 사용자',
      createdAt: new Date().toISOString(),
      role: 'user',
    },
  },
  measurements: {},
  healthScores: {},
  trendData: {},
  coachingLogs: {},
};

// 초기 데이터 생성
function initializeMockData() {
  const userId = 'user_123';
  const now = new Date();

  // 최근 10개 측정 데이터
  for (let i = 0; i < 10; i++) {
    const measurementId = uuidv4();
    const date = subDays(now, i);
    
    mockDB.measurements[measurementId] = {
      id: measurementId,
      userId,
      type: 'blood_glucose',
      value: Math.random() * (200 - 70) + 70, // 70-200
      unit: 'mg/dL',
      timestamp: date.toISOString(),
      location: 'fingertip',
      quality: Math.random() > 0.3 ? 'good' : 'fair',
    };
  }

  // 건강 점수
  mockDB.healthScores[userId] = {
    userId,
    score: 82,
    status: 'excellent',
    category: 'general',
    lastUpdated: now.toISOString(),
    metrics: {
      glucose: 78,
      bloodPressure: 120,
      heartRate: 72,
      sleep: 85,
      activity: 90,
    },
  };

  // 트렌드 데이터 (7일)
  mockDB.trendData[`${userId}_glucose_7d`] = {
    metricType: 'blood_glucose',
    userId,
    period: '7d',
    values: Array.from({ length: 7 }, () => Math.random() * (200 - 70) + 70),
    timestamps: Array.from({ length: 7 }, (_, i) => subDays(now, 6 - i).toISOString()),
    average: 95,
    min: 75,
    max: 185,
    trend: 'stable',
  };

  console.log('[Mock DB] 초기 데이터 생성 완료');
}

// ===== 헬스체크 =====
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    version: '1.0.0',
  });
});

// ===== Auth API =====

/**
 * POST /api/auth/login
 * 로그인 (Mock)
 */
app.post('/api/auth/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({
      error: 'email과 password는 필수입니다',
      code: 'INVALID_PARAMS',
    });
  }

  // Mock: 모든 로그인 성공
  const user = mockDB.users['user_123'];

  res.json({
    success: true,
    user: {
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
    },
    token: `mock_token_${uuidv4()}`,
    refreshToken: `mock_refresh_${uuidv4()}`,
    expiresIn: 3600,
  });
});

/**
 * POST /api/auth/signup
 * 회원가입 (Mock)
 */
app.post('/api/auth/signup', (req, res) => {
  const { email, password, name } = req.body;

  if (!email || !password || !name) {
    return res.status(400).json({
      error: '이메일, 비밀번호, 이름은 필수입니다',
      code: 'INVALID_PARAMS',
    });
  }

  const userId = uuidv4();
  const newUser = {
    id: userId,
    email,
    name,
    createdAt: new Date().toISOString(),
    role: 'user',
  };

  mockDB.users[userId] = newUser;

  res.status(201).json({
    success: true,
    user: newUser,
    token: `mock_token_${uuidv4()}`,
    message: '회원가입 성공',
  });
});

/**
 * POST /api/auth/logout
 * 로그아웃 (Mock)
 */
app.post('/api/auth/logout', (req, res) => {
  res.json({
    success: true,
    message: '로그아웃 성공',
  });
});

// ===== Measurement API =====

/**
 * POST /api/measurements
 * 측정 데이터 저장
 */
app.post('/api/measurements', (req, res) => {
  const { userId, type, value, unit, location } = req.body;

  if (!userId || !type || value === undefined || !unit) {
    return res.status(400).json({
      error: '필수 필드가 누락되었습니다',
      code: 'INVALID_PARAMS',
      required: ['userId', 'type', 'value', 'unit'],
    });
  }

  const measurementId = uuidv4();
  const measurement = {
    id: measurementId,
    userId,
    type,
    value,
    unit,
    location: location || 'unknown',
    timestamp: new Date().toISOString(),
    quality: 'good',
  };

  mockDB.measurements[measurementId] = measurement;

  res.status(201).json({
    success: true,
    data: measurement,
    message: '측정 데이터 저장 성공',
  });
});

/**
 * GET /api/measurements/:measurementId
 * 특정 측정 데이터 조회
 */
app.get('/api/measurements/:measurementId', (req, res) => {
  const { measurementId } = req.params;
  const measurement = mockDB.measurements[measurementId];

  if (!measurement) {
    return res.status(404).json({
      error: '측정 데이터를 찾을 수 없습니다',
      code: 'NOT_FOUND',
    });
  }

  res.json({
    success: true,
    data: measurement,
  });
});

/**
 * GET /api/measurements/:userId?limit=10
 * 사용자의 측정 이력 조회
 */
app.get('/api/measurements', (req, res) => {
  const { userId } = req.query;
  const limit = parseInt(req.query.limit) || 10;

  if (!userId) {
    return res.status(400).json({
      error: 'userId는 필수입니다',
      code: 'INVALID_PARAMS',
    });
  }

  const userMeasurements = Object.values(mockDB.measurements)
    .filter(m => m.userId === userId)
    .sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp))
    .slice(0, limit);

  res.json({
    success: true,
    data: userMeasurements,
    count: userMeasurements.length,
  });
});

/**
 * GET /api/measurements/history/:userId?startDate=&endDate=
 * 특정 기간의 측정 데이터 조회
 */
app.get('/api/measurements/history/:userId', (req, res) => {
  const { userId } = req.params;
  const { startDate, endDate } = req.query;

  const measurements = Object.values(mockDB.measurements)
    .filter(m => m.userId === userId)
    .filter(m => {
      if (startDate && new Date(m.timestamp) < new Date(startDate)) return false;
      if (endDate && new Date(m.timestamp) > new Date(endDate)) return false;
      return true;
    })
    .sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp));

  res.json({
    success: true,
    data: measurements,
    count: measurements.length,
    period: { startDate, endDate },
  });
});

// ===== Health Data API =====

/**
 * GET /api/health/score/:userId
 * 사용자의 건강 점수 조회
 */
app.get('/api/health/score/:userId', (req, res) => {
  const { userId } = req.params;
  const healthScore = mockDB.healthScores[userId];

  if (!healthScore) {
    return res.status(404).json({
      error: '건강 점수를 찾을 수 없습니다',
      code: 'NOT_FOUND',
    });
  }

  res.json({
    success: true,
    data: healthScore,
  });
});

/**
 * GET /api/environment/current
 * 현재 환경 정보 조회
 */
app.get('/api/environment/current', (req, res) => {
  res.json({
    success: true,
    data: {
      temperature: 22.5,
      humidity: 55,
      airQuality: 42,
      lightLevel: 'bright',
      timestamp: new Date().toISOString(),
    },
  });
});

// ===== Trend & Analytics API =====

/**
 * GET /api/trends/:userId?metric=&days=
 * 트렌드 데이터 조회
 */
app.get('/api/trends/:userId', (req, res) => {
  const { userId } = req.params;
  const { metric = 'blood_glucose', days = 7 } = req.query;

  const trendKey = `${userId}_${metric}_${days}d`;
  const trend = mockDB.trendData[trendKey] || {
    metricType: metric,
    userId,
    period: `${days}d`,
    values: Array.from({ length: parseInt(days) }, () => Math.random() * 100),
    timestamps: Array.from({ length: parseInt(days) }, (_, i) =>
      subDays(new Date(), parseInt(days) - 1 - i).toISOString()
    ),
    average: 95,
    min: 70,
    max: 185,
    trend: ['up', 'down', 'stable'][Math.floor(Math.random() * 3)],
  };

  res.json({
    success: true,
    data: trend,
  });
});

/**
 * GET /api/correlations/:userId?metric1=&metric2=
 * 상관관계 분석
 */
app.get('/api/correlations/:userId', (req, res) => {
  const { userId } = req.params;
  const { metric1 = 'glucose', metric2 = 'stress' } = req.query;

  res.json({
    success: true,
    data: {
      metric1,
      metric2,
      correlationCoefficient: (Math.random() - 0.5) * 2, // -1 to 1
      correlation: Math.random() > 0.5 ? 'positive' : 'negative',
      significance: Math.random() > 0.5,
    },
  });
});

/**
 * POST /api/reports/generate
 * 보고서 생성
 */
app.post('/api/reports/generate', (req, res) => {
  const { userId, startDate, endDate } = req.body;

  if (!userId || !startDate || !endDate) {
    return res.status(400).json({
      error: '필수 필드가 누락되었습니다',
      code: 'INVALID_PARAMS',
    });
  }

  res.json({
    success: true,
    data: {
      reportId: uuidv4(),
      userId,
      generatedAt: new Date().toISOString(),
      period: { startDate, endDate },
      summary: {
        totalMeasurements: 42,
        averageValue: 95.5,
        trend: 'improving',
        riskLevel: 'low',
      },
      recommendations: [
        '규칙적인 운동을 계속하세요',
        '수분 섭취를 늘리세요',
        '스트레스 관리를 해주세요',
      ],
    },
  });
});

/**
 * GET /api/family/:userId
 * 가족 멤버 데이터 조회
 */
app.get('/api/family/:userId', (req, res) => {
  const { userId } = req.params;

  res.json({
    success: true,
    data: [
      {
        memberId: uuidv4(),
        name: '배우자',
        relationship: 'spouse',
        medicalId: 'MED_001',
        lastMeasurement: subDays(new Date(), 1).toISOString(),
      },
      {
        memberId: uuidv4(),
        name: '자녀',
        relationship: 'child',
        medicalId: 'MED_002',
        lastMeasurement: subDays(new Date(), 3).toISOString(),
      },
    ],
  });
});

// ===== Coaching API =====

/**
 * POST /api/coaching/recommendations
 * 코칭 권장사항 생성
 */
app.post('/api/coaching/recommendations', (req, res) => {
  const { userId, category = 'exercise' } = req.body;

  const recommendations = {
    exercise: [
      '오늘은 30분 산책을 추천합니다',
      '스트레칭으로 시작하세요',
    ],
    nutrition: [
      '수분을 충분히 섭취하세요',
      '단백질 섭취를 늘리세요',
    ],
    sleep: [
      '규칙적인 수면 시간을 유지하세요',
      '자기 1시간 전에 스크린을 멀리하세요',
    ],
    stress: [
      '명상을 실천해보세요',
      '깊은 호흡 운동을 해보세요',
    ],
  };

  res.json({
    success: true,
    data: {
      userId,
      category,
      recommendations: recommendations[category] || [],
      timestamp: new Date().toISOString(),
    },
  });
});

// ===== Error Handling =====

/**
 * 404 핸들러
 */
app.use((req, res) => {
  res.status(404).json({
    error: '엔드포인트를 찾을 수 없습니다',
    code: 'NOT_FOUND',
    path: req.path,
  });
});

/**
 * 에러 핸들러
 */
app.use((err, req, res, next) => {
  console.error('[Error]', err);
  res.status(500).json({
    error: '서버 오류가 발생했습니다',
    code: 'INTERNAL_SERVER_ERROR',
    message: process.env.NODE_ENV === 'development' ? err.message : undefined,
  });
});

// ===== 서버 시작 =====

initializeMockData();

app.listen(PORT, () => {
  console.log(`
╔═══════════════════════════════════════════════════════════╗
║     🚀 Manpasik Mock API Server 시작                       ║
║                                                            ║
║     📍 주소: http://localhost:${PORT}                    ║
║     🏥 상태: 정상 작동 중                                  ║
║     📊 Mock 데이터: 초기화 완료                            ║
║                                                            ║
║     Endpoints:                                            ║
║     - GET  /health                                        ║
║     - POST /api/auth/login                               ║
║     - POST /api/auth/signup                              ║
║     - POST /api/measurements                             ║
║     - GET  /api/measurements/:userId                     ║
║     - GET  /api/health/score/:userId                    ║
║     - GET  /api/trends/:userId                           ║
║     - POST /api/reports/generate                         ║
║                                                            ║
╚═══════════════════════════════════════════════════════════╝
  `);
});

module.exports = app;
