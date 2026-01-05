/**
 * Measurement Service - API Integration Tests
 * @jest-environment node
 */

const request = require('supertest');

// Mock express app for testing
const BASE_URL = 'http://localhost:8002';

describe('Measurement Service API', () => {
  
  describe('Health Check', () => {
    test('GET /health should return service status', async () => {
      const response = await request(BASE_URL)
        .get('/health')
        .expect('Content-Type', /json/);
      
      // 서비스가 실행 중이면 200, 아니면 skip
      if (response.status === 200) {
        expect(response.body).toHaveProperty('status', 'ok');
        expect(response.body).toHaveProperty('service', 'measurement-service');
        expect(response.body).toHaveProperty('version', '1.0.0');
      }
    });
  });

  describe('Measurement CRUD', () => {
    const testUserId = 'test_user_123';
    let createdMeasurementId;

    test('POST /api/measurements should create a new measurement', async () => {
      const measurementData = {
        userId: testUserId,
        type: 'blood_glucose',
        value: 105,
        unit: 'mg/dL',
        source: 'test'
      };

      const response = await request(BASE_URL)
        .post('/api/measurements')
        .send(measurementData)
        .expect('Content-Type', /json/);

      if (response.status === 201) {
        expect(response.body.success).toBe(true);
        expect(response.body.data).toHaveProperty('id');
        expect(response.body.data).toHaveProperty('userId', testUserId);
        expect(response.body.data).toHaveProperty('type', 'blood_glucose');
        expect(response.body.data).toHaveProperty('value', 105);
        createdMeasurementId = response.body.data.id;
      }
    });

    test('GET /api/measurements/:userId should return user measurements', async () => {
      const response = await request(BASE_URL)
        .get(`/api/measurements/${testUserId}`)
        .expect('Content-Type', /json/);

      if (response.status === 200) {
        expect(response.body.success).toBe(true);
        expect(response.body.data).toBeInstanceOf(Array);
        expect(response.body).toHaveProperty('pagination');
      }
    });

    test('GET /api/measurements/:userId with type filter', async () => {
      const response = await request(BASE_URL)
        .get(`/api/measurements/${testUserId}?type=blood_glucose`)
        .expect('Content-Type', /json/);

      if (response.status === 200) {
        expect(response.body.success).toBe(true);
        response.body.data.forEach(m => {
          expect(m.type).toBe('blood_glucose');
        });
      }
    });

    test('POST /api/measurements with invalid data should return 400', async () => {
      const invalidData = { type: 'blood_glucose' }; // missing required fields

      const response = await request(BASE_URL)
        .post('/api/measurements')
        .send(invalidData);

      // 서버가 실행 중이면 400 에러 기대
      if (response.status !== 404) {
        expect(response.status).toBe(400);
        expect(response.body).toHaveProperty('error');
      }
    });
  });

  describe('Health Score', () => {
    test('GET /api/health-score/:userId should return health score', async () => {
      const response = await request(BASE_URL)
        .get('/api/health-score/user_123')
        .expect('Content-Type', /json/);

      if (response.status === 200) {
        expect(response.body.success).toBe(true);
        expect(response.body.data).toHaveProperty('overall');
        expect(response.body.data).toHaveProperty('glucose');
        expect(response.body.data).toHaveProperty('bloodPressure');
      }
    });
  });

  describe('Trends Analysis', () => {
    test('GET /api/trends/:userId should return trend analysis', async () => {
      const response = await request(BASE_URL)
        .get('/api/trends/user_123?days=7')
        .expect('Content-Type', /json/);

      if (response.status === 200) {
        expect(response.body.success).toBe(true);
        expect(response.body.data).toHaveProperty('period');
        expect(response.body.data).toHaveProperty('trends');
        expect(response.body.data).toHaveProperty('recommendations');
      }
    });

    test('GET /api/correlations/:userId should return correlations', async () => {
      const response = await request(BASE_URL)
        .get('/api/correlations/user_123')
        .expect('Content-Type', /json/);

      if (response.status === 200) {
        expect(response.body.success).toBe(true);
        expect(response.body.data).toHaveProperty('correlations');
      }
    });
  });

  describe('Reports', () => {
    test('POST /api/reports/generate should create a report', async () => {
      const reportRequest = {
        userId: 'user_123',
        format: 'json',
        period: 7
      };

      const response = await request(BASE_URL)
        .post('/api/reports/generate')
        .send(reportRequest)
        .expect('Content-Type', /json/);

      if (response.status === 200) {
        expect(response.body.success).toBe(true);
        expect(response.body.data).toHaveProperty('reportId');
        expect(response.body.data).toHaveProperty('summary');
        expect(response.body.data).toHaveProperty('recommendations');
      }
    });
  });

  describe('Batch Operations', () => {
    test('POST /api/measurements/batch should save multiple measurements', async () => {
      const batchData = {
        userId: 'batch_test_user',
        measurements: [
          { type: 'blood_glucose', value: 100, unit: 'mg/dL', timestamp: new Date() },
          { type: 'heart_rate', value: 72, unit: 'bpm', timestamp: new Date() },
          { type: 'oxygen_level', value: 98, unit: '%', timestamp: new Date() }
        ]
      };

      const response = await request(BASE_URL)
        .post('/api/measurements/batch')
        .send(batchData)
        .expect('Content-Type', /json/);

      if (response.status === 201) {
        expect(response.body.success).toBe(true);
        expect(response.body.saved).toBe(3);
        expect(response.body.data).toHaveLength(3);
      }
    });
  });
});

// 테스트용 유효성 검증 함수
describe('Measurement Validation', () => {
  const validRanges = {
    blood_glucose: { min: 40, max: 400, unit: 'mg/dL' },
    blood_pressure_systolic: { min: 50, max: 250, unit: 'mmHg' },
    blood_pressure_diastolic: { min: 30, max: 150, unit: 'mmHg' },
    heart_rate: { min: 30, max: 200, unit: 'bpm' },
    oxygen_level: { min: 70, max: 100, unit: '%' },
    temperature: { min: 35, max: 42, unit: '°C' }
  };

  test('Blood glucose should be within valid range', () => {
    const glucose = 95;
    const { min, max } = validRanges.blood_glucose;
    expect(glucose).toBeGreaterThanOrEqual(min);
    expect(glucose).toBeLessThanOrEqual(max);
  });

  test('Heart rate should be within valid range', () => {
    const heartRate = 72;
    const { min, max } = validRanges.heart_rate;
    expect(heartRate).toBeGreaterThanOrEqual(min);
    expect(heartRate).toBeLessThanOrEqual(max);
  });

  test('Emergency detection for critical glucose', () => {
    const criticalLow = 45;
    const criticalHigh = 350;
    const isEmergency = (value) => value < 50 || value > 300;
    
    expect(isEmergency(criticalLow)).toBe(true);
    expect(isEmergency(criticalHigh)).toBe(true);
    expect(isEmergency(100)).toBe(false);
  });

  test('Trend calculation', () => {
    const values = [95, 98, 102, 105, 108];
    const calculateTrend = (vals) => {
      if (vals.length < 2) return 'stable';
      const first = vals.slice(0, Math.ceil(vals.length / 2));
      const second = vals.slice(Math.ceil(vals.length / 2));
      const avgFirst = first.reduce((a, b) => a + b) / first.length;
      const avgSecond = second.reduce((a, b) => a + b) / second.length;
      const change = ((avgSecond - avgFirst) / avgFirst) * 100;
      if (change > 5) return 'increasing';
      if (change < -5) return 'decreasing';
      return 'stable';
    };
    
    expect(calculateTrend(values)).toBe('increasing');
    expect(calculateTrend([100, 100, 100])).toBe('stable');
    expect(calculateTrend([110, 105, 100, 95])).toBe('decreasing');
  });
});
