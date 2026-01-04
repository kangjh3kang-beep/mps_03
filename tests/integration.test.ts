/**
 * Integration Tests for Manpasik Ecosystem
 * Tests all microservices endpoints and inter-service communication
 */

import request from 'supertest';
import { describe, it, expect, beforeAll, afterAll } from '@jest/globals';

const API_BASE_URL = process.env.API_BASE_URL || 'http://localhost:8080';
const AUTH_SERVICE_URL = process.env.AUTH_SERVICE_URL || 'http://localhost:8001';
const PAYMENT_SERVICE_URL = process.env.PAYMENT_SERVICE_URL || 'http://localhost:3004';

let authToken: string;

describe('Manpasik Ecosystem Integration Tests', () => {
  
  beforeAll(async () => {
    // Health check
    const healthCheck = await request(API_BASE_URL)
      .get('/health')
      .expect(200);
    
    console.log('✓ API Gateway is healthy');
  });

  afterAll(async () => {
    console.log('✓ Integration tests completed');
  });

  describe('Authentication Service', () => {
    it('should register a new user', async () => {
      const response = await request(AUTH_SERVICE_URL)
        .post('/auth/register')
        .send({
          email: 'test@manpasik.com',
          password: 'TestPassword123!',
          firstName: 'Test',
          lastName: 'User',
          phone: '+82-10-1234-5678'
        })
        .expect(201);

      expect(response.body).toHaveProperty('userId');
      expect(response.body).toHaveProperty('token');
      authToken = response.body.token;
    });

    it('should login with valid credentials', async () => {
      const response = await request(AUTH_SERVICE_URL)
        .post('/auth/login')
        .send({
          email: 'test@manpasik.com',
          password: 'TestPassword123!'
        })
        .expect(200);

      expect(response.body).toHaveProperty('token');
      expect(response.body).toHaveProperty('user');
      expect(response.body.user.email).toBe('test@manpasik.com');
    });

    it('should validate JWT token', async () => {
      const response = await request(AUTH_SERVICE_URL)
        .get('/auth/verify')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body).toHaveProperty('valid');
      expect(response.body.valid).toBe(true);
    });

    it('should refresh token', async () => {
      const response = await request(AUTH_SERVICE_URL)
        .post('/auth/refresh')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body).toHaveProperty('token');
    });

    it('should logout user', async () => {
      const response = await request(AUTH_SERVICE_URL)
        .post('/auth/logout')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body).toHaveProperty('message');
    });
  });

  describe('Measurement Service', () => {
    it('should create a new measurement', async () => {
      const response = await request(API_BASE_URL)
        .post('/measurement/create')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          type: 'blood_pressure',
          systolic: 120,
          diastolic: 80,
          pulse: 70,
          timestamp: new Date().toISOString(),
          notes: 'Morning measurement'
        })
        .expect(201);

      expect(response.body).toHaveProperty('measurementId');
      expect(response.body.type).toBe('blood_pressure');
    });

    it('should retrieve measurements', async () => {
      const response = await request(API_BASE_URL)
        .get('/measurement/list')
        .set('Authorization', `Bearer ${authToken}`)
        .query({ limit: 10, offset: 0 })
        .expect(200);

      expect(Array.isArray(response.body.measurements)).toBe(true);
      expect(response.body).toHaveProperty('total');
    });

    it('should analyze measurement data', async () => {
      const response = await request(API_BASE_URL)
        .post('/measurement/analyze')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          startDate: new Date(Date.now() - 7*24*60*60*1000).toISOString(),
          endDate: new Date().toISOString(),
          types: ['blood_pressure', 'heart_rate']
        })
        .expect(200);

      expect(response.body).toHaveProperty('summary');
      expect(response.body).toHaveProperty('trends');
    });
  });

  describe('Payment Service', () => {
    it('should create a payment intent', async () => {
      const response = await request(PAYMENT_SERVICE_URL)
        .post('/payment/intent')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          amount: 29900,
          currency: 'KRW',
          description: 'Premium Subscription - Monthly'
        })
        .expect(201);

      expect(response.body).toHaveProperty('clientSecret');
      expect(response.body).toHaveProperty('intentId');
    });

    it('should process payment', async () => {
      const response = await request(PAYMENT_SERVICE_URL)
        .post('/payment/process')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          intentId: 'test-intent',
          paymentMethod: 'card',
          cardToken: 'test-token'
        })
        .expect(200);

      expect(response.body).toHaveProperty('transactionId');
      expect(response.body.status).toBe('completed');
    });

    it('should retrieve payment history', async () => {
      const response = await request(PAYMENT_SERVICE_URL)
        .get('/payment/history')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(Array.isArray(response.body.transactions)).toBe(true);
    });

    it('should generate invoice', async () => {
      const response = await request(PAYMENT_SERVICE_URL)
        .post('/payment/invoice')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          transactionId: 'test-transaction'
        })
        .expect(200);

      expect(response.body).toHaveProperty('invoiceUrl');
      expect(response.body).toHaveProperty('invoiceNumber');
    });
  });

  describe('Notification Service', () => {
    it('should send notification', async () => {
      const response = await request(API_BASE_URL)
        .post('/notification/send')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          title: 'Test Notification',
          message: 'This is a test notification',
          type: 'measurement_alert'
        })
        .expect(200);

      expect(response.body).toHaveProperty('notificationId');
    });

    it('should retrieve notifications', async () => {
      const response = await request(API_BASE_URL)
        .get('/notification/list')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(Array.isArray(response.body.notifications)).toBe(true);
    });

    it('should mark notification as read', async () => {
      const response = await request(API_BASE_URL)
        .patch('/notification/mark-read')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          notificationId: 'test-notification'
        })
        .expect(200);

      expect(response.body.read).toBe(true);
    });

    it('should subscribe to push notifications', async () => {
      const response = await request(API_BASE_URL)
        .post('/notification/subscribe')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          endpoint: 'https://example.com/push',
          auth: 'test-auth-key',
          p256dh: 'test-p256dh-key'
        })
        .expect(200);

      expect(response.body).toHaveProperty('subscriptionId');
    });
  });

  describe('Video Service', () => {
    it('should create video session', async () => {
      const response = await request(API_BASE_URL)
        .post('/video/session')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          type: 'consultation',
          participants: ['user1', 'doctor1'],
          duration: 60
        })
        .expect(201);

      expect(response.body).toHaveProperty('sessionId');
      expect(response.body).toHaveProperty('token');
    });

    it('should record video session', async () => {
      const response = await request(API_BASE_URL)
        .post('/video/record')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          sessionId: 'test-session'
        })
        .expect(200);

      expect(response.body).toHaveProperty('recordingId');
    });

    it('should retrieve video recordings', async () => {
      const response = await request(API_BASE_URL)
        .get('/video/recordings')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(Array.isArray(response.body.recordings)).toBe(true);
    });
  });

  describe('Translation Service', () => {
    it('should translate text', async () => {
      const response = await request(API_BASE_URL)
        .post('/translate/text')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          text: 'Hello, how are you?',
          sourceLanguage: 'en',
          targetLanguage: 'ko'
        })
        .expect(200);

      expect(response.body).toHaveProperty('translatedText');
      expect(response.body).toHaveProperty('targetLanguage');
    });

    it('should detect language', async () => {
      const response = await request(API_BASE_URL)
        .post('/translate/detect')
        .send({
          text: 'Bonjour, comment allez-vous?'
        })
        .expect(200);

      expect(response.body).toHaveProperty('detectedLanguage');
    });

    it('should get supported languages', async () => {
      const response = await request(API_BASE_URL)
        .get('/translate/languages')
        .expect(200);

      expect(Array.isArray(response.body.languages)).toBe(true);
      expect(response.body.languages.length).toBeGreaterThan(0);
    });
  });

  describe('AI Service', () => {
    it('should analyze health data', async () => {
      const response = await request(API_BASE_URL)
        .post('/ai/analyze')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          dataType: 'blood_pressure',
          data: [
            { timestamp: '2024-01-01T10:00:00Z', systolic: 120, diastolic: 80 },
            { timestamp: '2024-01-02T10:00:00Z', systolic: 125, diastolic: 82 }
          ],
          period: 7
        })
        .expect(200);

      expect(response.body).toHaveProperty('analysis');
      expect(response.body).toHaveProperty('recommendations');
    });

    it('should get health insights', async () => {
      const response = await request(API_BASE_URL)
        .get('/ai/insights')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body).toHaveProperty('insights');
      expect(Array.isArray(response.body.insights)).toBe(true);
    });

    it('should predict health risks', async () => {
      const response = await request(API_BASE_URL)
        .post('/ai/predict')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          factors: {
            age: 45,
            bmi: 24.5,
            smokingStatus: false,
            exerciseFrequency: 3
          }
        })
        .expect(200);

      expect(response.body).toHaveProperty('riskScore');
      expect(response.body).toHaveProperty('riskFactors');
    });
  });

  describe('Admin Service', () => {
    it('should get system health metrics', async () => {
      const response = await request(API_BASE_URL)
        .get('/admin/health')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body).toHaveProperty('status');
      expect(response.body).toHaveProperty('timestamp');
      expect(response.body).toHaveProperty('services');
    });

    it('should get system statistics', async () => {
      const response = await request(API_BASE_URL)
        .get('/admin/stats')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body).toHaveProperty('totalUsers');
      expect(response.body).toHaveProperty('activeUsers');
      expect(response.body).toHaveProperty('totalMeasurements');
    });
  });

  describe('Cross-Service Integration', () => {
    it('should handle complete user workflow', async () => {
      // 1. Register user
      const registerRes = await request(AUTH_SERVICE_URL)
        .post('/auth/register')
        .send({
          email: 'workflow@manpasik.com',
          password: 'TestPassword123!',
          firstName: 'Workflow',
          lastName: 'Test'
        })
        .expect(201);

      const token = registerRes.body.token;

      // 2. Create measurement
      const measureRes = await request(API_BASE_URL)
        .post('/measurement/create')
        .set('Authorization', `Bearer ${token}`)
        .send({
          type: 'blood_pressure',
          systolic: 130,
          diastolic: 85,
          pulse: 75
        })
        .expect(201);

      // 3. Get AI analysis
      const analysisRes = await request(API_BASE_URL)
        .post('/ai/analyze')
        .set('Authorization', `Bearer ${token}`)
        .send({
          dataType: 'blood_pressure',
          data: [measureRes.body]
        })
        .expect(200);

      // 4. Send notification
      const notifRes = await request(API_BASE_URL)
        .post('/notification/send')
        .set('Authorization', `Bearer ${token}`)
        .send({
          title: 'Health Analysis Complete',
          message: analysisRes.body.recommendations[0]
        })
        .expect(200);

      expect(notifRes.body).toHaveProperty('notificationId');
    });
  });

  describe('Error Handling', () => {
    it('should return 401 for missing auth token', async () => {
      const response = await request(API_BASE_URL)
        .get('/measurement/list')
        .expect(401);

      expect(response.body).toHaveProperty('error');
    });

    it('should return 404 for non-existent endpoint', async () => {
      const response = await request(API_BASE_URL)
        .get('/non-existent')
        .expect(404);

      expect(response.body).toHaveProperty('error');
    });

    it('should return 400 for invalid request', async () => {
      const response = await request(API_BASE_URL)
        .post('/measurement/create')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          // Missing required fields
        })
        .expect(400);

      expect(response.body).toHaveProperty('error');
    });

    it('should return 500 for server error gracefully', async () => {
      const response = await request(API_BASE_URL)
        .post('/ai/analyze')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          dataType: 'invalid_type',
          data: []
        });

      expect([400, 500]).toContain(response.status);
      expect(response.body).toHaveProperty('error');
    });
  });

  describe('Performance Tests', () => {
    it('should handle concurrent requests', async () => {
      const requests = Array(10)
        .fill(null)
        .map(() =>
          request(API_BASE_URL)
            .get('/measurement/list')
            .set('Authorization', `Bearer ${authToken}`)
        );

      const responses = await Promise.all(requests);
      
      responses.forEach(res => {
        expect(res.status).toBe(200);
      });
    });

    it('should respond within acceptable time', async () => {
      const startTime = Date.now();
      
      await request(API_BASE_URL)
        .get('/measurement/list')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      const responseTime = Date.now() - startTime;
      expect(responseTime).toBeLessThan(5000); // 5 second timeout
    });
  });
});
