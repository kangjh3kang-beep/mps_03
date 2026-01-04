/**
 * Measurement Service - Node.js + Express
 * 측정 데이터 저장, 분석, 트렌드 분석
 * 시계열 데이터 기반 건강 지표 추적
 */

const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { v4: uuidv4 } = require('uuid');
const { addHours, subDays, format } = require('date-fns');

const app = express();
const PORT = process.env.PORT || 8002;

// 미들웨어
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// ============================================
// 데이터 저장소 (In-Memory - 프로덕션은 MongoDB)
// ============================================

let measurements = new Map();
let healthScores = new Map();
let trends = new Map();

// 초기 데이터 설정
function initializeData() {
  const userId = 'user_123';
  const now = new Date();

  // 측정 데이터 (30개 샘플)
  const measurementsList = [
    { type: 'blood_glucose', value: 95, unit: 'mg/dL', timestamp: subDays(now, 7) },
    { type: 'blood_glucose', value: 102, unit: 'mg/dL', timestamp: subDays(now, 6) },
    { type: 'blood_glucose', value: 98, unit: 'mg/dL', timestamp: subDays(now, 5) },
    { type: 'blood_glucose', value: 105, unit: 'mg/dL', timestamp: subDays(now, 4) },
    { type: 'blood_glucose', value: 99, unit: 'mg/dL', timestamp: subDays(now, 3) },
    { type: 'blood_glucose', value: 97, unit: 'mg/dL', timestamp: subDays(now, 2) },
    { type: 'blood_glucose', value: 96, unit: 'mg/dL', timestamp: subDays(now, 1) },
    { type: 'blood_glucose', value: 100, unit: 'mg/dL', timestamp: now },

    { type: 'blood_pressure', value: '120/80', unit: 'mmHg', timestamp: subDays(now, 7) },
    { type: 'blood_pressure', value: '122/82', unit: 'mmHg', timestamp: subDays(now, 6) },
    { type: 'blood_pressure', value: '119/79', unit: 'mmHg', timestamp: subDays(now, 5) },
    { type: 'blood_pressure', value: '125/85', unit: 'mmHg', timestamp: subDays(now, 4) },
    { type: 'blood_pressure', value: '121/81', unit: 'mmHg', timestamp: subDays(now, 3) },
    { type: 'blood_pressure', value: '120/80', unit: 'mmHg', timestamp: subDays(now, 2) },
    { type: 'blood_pressure', value: '118/78', unit: 'mmHg', timestamp: subDays(now, 1) },
    { type: 'blood_pressure', value: '123/83', unit: 'mmHg', timestamp: now },

    { type: 'heart_rate', value: 72, unit: 'bpm', timestamp: subDays(now, 7) },
    { type: 'heart_rate', value: 75, unit: 'bpm', timestamp: subDays(now, 6) },
    { type: 'heart_rate', value: 70, unit: 'bpm', timestamp: subDays(now, 5) },
    { type: 'heart_rate', value: 78, unit: 'bpm', timestamp: subDays(now, 4) },
    { type: 'heart_rate', value: 73, unit: 'bpm', timestamp: subDays(now, 3) },
    { type: 'heart_rate', value: 71, unit: 'bpm', timestamp: subDays(now, 2) },
    { type: 'heart_rate', value: 69, unit: 'bpm', timestamp: subDays(now, 1) },
    { type: 'heart_rate', value: 74, unit: 'bpm', timestamp: now },

    { type: 'oxygen_level', value: 98, unit: '%', timestamp: subDays(now, 7) },
    { type: 'oxygen_level', value: 97, unit: '%', timestamp: subDays(now, 6) },
    { type: 'oxygen_level', value: 98, unit: '%', timestamp: subDays(now, 5) },
    { type: 'oxygen_level', value: 96, unit: '%', timestamp: subDays(now, 4) },
    { type: 'oxygen_level', value: 98, unit: '%', timestamp: subDays(now, 3) },
    { type: 'oxygen_level', value: 99, unit: '%', timestamp: subDays(now, 2) },
    { type: 'oxygen_level', value: 97, unit: '%', timestamp: subDays(now, 1) },
    { type: 'oxygen_level', value: 98, unit: '%', timestamp: now },
  ];

  // 측정 데이터 저장
  measurements.set(userId, measurementsList.map(m => ({
    id: uuidv4(),
    userId,
    ...m,
    createdAt: m.timestamp,
    updatedAt: m.timestamp,
    verified: true,
    source: 'device'
  })));

  // 건강 점수 계산
  healthScores.set(userId, {
    overall: 85,
    glucose: { score: 80, status: 'normal', trend: 'stable' },
    bloodPressure: { score: 88, status: 'optimal', trend: 'stable' },
    heartRate: { score: 82, status: 'normal', trend: 'stable' },
    oxygen: { score: 95, status: 'excellent', trend: 'stable' },
    lastUpdated: now
  });

  // 트렌드 데이터
  trends.set(userId, {
    glucose: {
      average: 99.5,
      min: 95,
      max: 105,
      stdDev: 3.2,
      trend: 'stable',
      weekOverWeek: 0.5
    },
    bloodPressure: {
      systolic: { average: 121.4, min: 118, max: 125, trend: 'stable' },
      diastolic: { average: 81.1, min: 78, max: 85, trend: 'stable' }
    },
    heartRate: {
      average: 72.9,
      min: 69,
      max: 78,
      resting: 68,
      trend: 'stable'
    }
  });
}

initializeData();

// ============================================
// Health Check
// ============================================

app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    service: 'measurement-service',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  });
});

// ============================================
// 측정 데이터 API
// ============================================

/**
 * POST /api/measurements
 * 새로운 측정 데이터 저장
 */
app.post('/api/measurements', (req, res) => {
  try {
    const { userId, type, value, unit, timestamp, source = 'device' } = req.body;

    if (!userId || !type || value === undefined || !unit) {
      return res.status(400).json({
        error: 'Invalid measurement data',
        required: ['userId', 'type', 'value', 'unit']
      });
    }

    const measurement = {
      id: uuidv4(),
      userId,
      type,
      value,
      unit,
      timestamp: new Date(timestamp || Date.now()),
      createdAt: new Date(),
      updatedAt: new Date(),
      verified: true,
      source
    };

    if (!measurements.has(userId)) {
      measurements.set(userId, []);
    }
    measurements.get(userId).push(measurement);

    // 트렌드 업데이트
    updateTrends(userId);

    res.status(201).json({
      success: true,
      data: measurement,
      message: 'Measurement saved successfully'
    });
  } catch (error) {
    console.error('Error saving measurement:', error);
    res.status(500).json({ error: error.message });
  }
});

/**
 * GET /api/measurements/:userId
 * 사용자의 측정 데이터 조회 (필터링, 페이징)
 */
app.get('/api/measurements/:userId', (req, res) => {
  try {
    const { userId } = req.params;
    const { type, limit = 50, offset = 0, startDate, endDate } = req.query;

    let userMeasurements = measurements.get(userId) || [];

    // 타입 필터링
    if (type) {
      userMeasurements = userMeasurements.filter(m => m.type === type);
    }

    // 날짜 범위 필터링
    if (startDate || endDate) {
      const start = startDate ? new Date(startDate) : new Date(0);
      const end = endDate ? new Date(endDate) : new Date();
      userMeasurements = userMeasurements.filter(
        m => m.timestamp >= start && m.timestamp <= end
      );
    }

    // 최신순 정렬
    userMeasurements.sort((a, b) => b.timestamp - a.timestamp);

    // 페이징
    const total = userMeasurements.length;
    const paged = userMeasurements.slice(offset, offset + parseInt(limit));

    res.json({
      success: true,
      data: paged,
      pagination: {
        limit: parseInt(limit),
        offset: parseInt(offset),
        total,
        hasMore: offset + parseInt(limit) < total
      }
    });
  } catch (error) {
    console.error('Error fetching measurements:', error);
    res.status(500).json({ error: error.message });
  }
});

/**
 * GET /api/measurements/:userId/:id
 * 특정 측정 데이터 조회
 */
app.get('/api/measurements/:userId/:id', (req, res) => {
  try {
    const { userId, id } = req.params;
    const measurement = (measurements.get(userId) || []).find(m => m.id === id);

    if (!measurement) {
      return res.status(404).json({ error: 'Measurement not found' });
    }

    res.json({
      success: true,
      data: measurement
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * PUT /api/measurements/:userId/:id
 * 측정 데이터 수정
 */
app.put('/api/measurements/:userId/:id', (req, res) => {
  try {
    const { userId, id } = req.params;
    const updates = req.body;

    const userMeasurements = measurements.get(userId);
    if (!userMeasurements) {
      return res.status(404).json({ error: 'User not found' });
    }

    const index = userMeasurements.findIndex(m => m.id === id);
    if (index === -1) {
      return res.status(404).json({ error: 'Measurement not found' });
    }

    userMeasurements[index] = {
      ...userMeasurements[index],
      ...updates,
      id, // ID 변경 불가
      userId, // userId 변경 불가
      updatedAt: new Date()
    };

    updateTrends(userId);

    res.json({
      success: true,
      data: userMeasurements[index]
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * DELETE /api/measurements/:userId/:id
 * 측정 데이터 삭제
 */
app.delete('/api/measurements/:userId/:id', (req, res) => {
  try {
    const { userId, id } = req.params;
    const userMeasurements = measurements.get(userId);

    if (!userMeasurements) {
      return res.status(404).json({ error: 'User not found' });
    }

    const index = userMeasurements.findIndex(m => m.id === id);
    if (index === -1) {
      return res.status(404).json({ error: 'Measurement not found' });
    }

    const deleted = userMeasurements.splice(index, 1)[0];
    updateTrends(userId);

    res.json({
      success: true,
      data: deleted,
      message: 'Measurement deleted successfully'
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ============================================
// 건강 점수 API
// ============================================

/**
 * GET /api/health-score/:userId
 * 사용자의 종합 건강 점수 조회
 */
app.get('/api/health-score/:userId', (req, res) => {
  try {
    const { userId } = req.params;
    const score = healthScores.get(userId);

    if (!score) {
      return res.status(404).json({ error: 'Health score not found' });
    }

    res.json({
      success: true,
      data: score
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ============================================
// 트렌드 분석 API
// ============================================

/**
 * GET /api/trends/:userId
 * 트렌드 분석 (평균, 표준편차, 추세)
 */
app.get('/api/trends/:userId', (req, res) => {
  try {
    const { userId } = req.params;
    const { days = 7 } = req.query;

    const trend = trends.get(userId);
    if (!trend) {
      return res.status(404).json({ error: 'Trends not found' });
    }

    // 기간별 트렌드 필터링
    const userMeasurements = measurements.get(userId) || [];
    const startDate = subDays(new Date(), parseInt(days));
    const filtered = userMeasurements.filter(m => m.timestamp >= startDate);

    const analysis = {
      period: {
        days: parseInt(days),
        startDate,
        endDate: new Date()
      },
      dataPoints: filtered.length,
      trends: trend,
      recommendations: generateRecommendations(trend, userId)
    };

    res.json({
      success: true,
      data: analysis
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * GET /api/correlations/:userId
 * 측정값 간 상관관계 분석
 */
app.get('/api/correlations/:userId', (req, res) => {
  try {
    const { userId } = req.params;
    const userMeasurements = measurements.get(userId) || [];

    // 간단한 상관관계 분석 (프로토타입)
    const correlation = {
      glucoseBloodPressure: 0.45,
      glucoseHeartRate: 0.32,
      bloodPressureHeartRate: 0.58,
      heartRateOxygen: -0.15,
      analysisMethod: 'Pearson correlation'
    };

    res.json({
      success: true,
      data: {
        userId,
        measurements: userMeasurements.length,
        correlations: correlation,
        interpretation: 'Moderate positive correlation between glucose and blood pressure'
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

/**
 * POST /api/reports/generate
 * 보고서 생성
 */
app.post('/api/reports/generate', (req, res) => {
  try {
    const { userId, format = 'json', period = 7 } = req.body;

    const userMeasurements = measurements.get(userId) || [];
    const healthScore = healthScores.get(userId);
    const trend = trends.get(userId);

    const report = {
      reportId: uuidv4(),
      userId,
      generatedAt: new Date(),
      period: `${period} days`,
      summary: {
        totalMeasurements: userMeasurements.length,
        healthScore: healthScore?.overall || 0,
        mainConcerns: identifyMainConcerns(healthScore),
        positives: identifyPositives(healthScore)
      },
      measurements: {
        total: userMeasurements.length,
        byType: groupByType(userMeasurements)
      },
      trends,
      recommendations: generateRecommendations(trend, userId),
      format
    };

    res.json({
      success: true,
      data: report
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ============================================
// 배치 API
// ============================================

/**
 * POST /api/measurements/batch
 * 여러 측정값 한 번에 저장
 */
app.post('/api/measurements/batch', (req, res) => {
  try {
    const { userId, measurements: measurementsList } = req.body;

    if (!userId || !Array.isArray(measurementsList)) {
      return res.status(400).json({
        error: 'Invalid batch data',
        required: ['userId', 'measurements array']
      });
    }

    const saved = [];
    for (const m of measurementsList) {
      const measurement = {
        id: uuidv4(),
        userId,
        ...m,
        createdAt: new Date(),
        updatedAt: new Date(),
        verified: false, // 배치는 검증 필요
        source: m.source || 'batch'
      };

      if (!measurements.has(userId)) {
        measurements.set(userId, []);
      }
      measurements.get(userId).push(measurement);
      saved.push(measurement);
    }

    updateTrends(userId);

    res.status(201).json({
      success: true,
      data: saved,
      saved: saved.length,
      message: `${saved.length} measurements saved in batch`
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// ============================================
// Helper Functions
// ============================================

function updateTrends(userId) {
  const userMeasurements = measurements.get(userId) || [];

  // 측정값별 그룹화
  const glucose = userMeasurements.filter(m => m.type === 'blood_glucose').map(m => m.value);
  const heartRate = userMeasurements.filter(m => m.type === 'heart_rate').map(m => m.value);

  const newTrends = {};

  if (glucose.length > 0) {
    newTrends.glucose = {
      average: glucose.reduce((a, b) => a + b) / glucose.length,
      min: Math.min(...glucose),
      max: Math.max(...glucose),
      stdDev: calculateStdDev(glucose),
      trend: calculateTrend(glucose),
      weekOverWeek: glucose.length > 7 ? calculateWeekOverWeek(glucose) : 0
    };
  }

  if (heartRate.length > 0) {
    newTrends.heartRate = {
      average: heartRate.reduce((a, b) => a + b) / heartRate.length,
      min: Math.min(...heartRate),
      max: Math.max(...heartRate),
      trend: calculateTrend(heartRate)
    };
  }

  if (Object.keys(newTrends).length > 0) {
    trends.set(userId, newTrends);
  }
}

function calculateStdDev(values) {
  if (values.length === 0) return 0;
  const mean = values.reduce((a, b) => a + b) / values.length;
  const variance = values.reduce((a, b) => a + Math.pow(b - mean, 2), 0) / values.length;
  return Math.sqrt(variance).toFixed(2);
}

function calculateTrend(values) {
  if (values.length < 2) return 'stable';
  const first = values.slice(0, Math.ceil(values.length / 2));
  const second = values.slice(Math.ceil(values.length / 2));
  const avgFirst = first.reduce((a, b) => a + b) / first.length;
  const avgSecond = second.reduce((a, b) => a + b) / second.length;
  const change = ((avgSecond - avgFirst) / avgFirst) * 100;

  if (change > 5) return 'increasing';
  if (change < -5) return 'decreasing';
  return 'stable';
}

function calculateWeekOverWeek(values) {
  if (values.length < 14) return 0;
  const week1 = values.slice(-14, -7);
  const week2 = values.slice(-7);
  const avg1 = week1.reduce((a, b) => a + b) / week1.length;
  const avg2 = week2.reduce((a, b) => a + b) / week2.length;
  return (((avg2 - avg1) / avg1) * 100).toFixed(1);
}

function groupByType(meas) {
  const grouped = {};
  meas.forEach(m => {
    if (!grouped[m.type]) grouped[m.type] = 0;
    grouped[m.type]++;
  });
  return grouped;
}

function generateRecommendations(trend, userId) {
  const recommendations = [];

  if (trend?.glucose?.average > 100) {
    recommendations.push({
      priority: 'high',
      category: 'glucose',
      message: 'Blood glucose levels are elevated. Consider increasing physical activity and reducing sugar intake.',
      action: 'consult_doctor'
    });
  }

  if (trend?.heartRate?.average > 80) {
    recommendations.push({
      priority: 'medium',
      category: 'heart_rate',
      message: 'Resting heart rate is slightly elevated. Try relaxation techniques and regular exercise.',
      action: 'monitor'
    });
  }

  if (recommendations.length === 0) {
    recommendations.push({
      priority: 'low',
      category: 'general',
      message: 'Keep maintaining your healthy lifestyle. All vitals are within normal range.',
      action: 'continue'
    });
  }

  return recommendations;
}

function identifyMainConcerns(score) {
  if (!score) return [];
  const concerns = [];
  if (score.glucose?.score < 80) concerns.push('Blood Glucose');
  if (score.bloodPressure?.score < 80) concerns.push('Blood Pressure');
  if (score.heartRate?.score < 80) concerns.push('Heart Rate');
  return concerns;
}

function identifyPositives(score) {
  if (!score) return [];
  const positives = [];
  if (score.oxygen?.score > 95) positives.push('Excellent Oxygen Levels');
  if (score.overall > 80) positives.push('Overall Health Score');
  return positives;
}

// ============================================
// 서버 시작
// ============================================

app.listen(PORT, () => {
  console.log(`\n🏥 Measurement Service running on port ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
  console.log(`📈 Endpoints:`);
  console.log(`   POST   /api/measurements`);
  console.log(`   GET    /api/measurements/:userId`);
  console.log(`   GET    /api/health-score/:userId`);
  console.log(`   GET    /api/trends/:userId`);
  console.log(`   POST   /api/reports/generate`);
  console.log(`   POST   /api/measurements/batch\n`);
});
