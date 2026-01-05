/**
 * 만파식 생태계 - 서비스 간 통신 클라이언트
 * 마이크로서비스 간 HTTP 통신을 위한 공통 유틸리티
 */

const axios = require('axios');

// 서비스 엔드포인트 정의
const SERVICE_ENDPOINTS = {
  auth: process.env.AUTH_SERVICE_URL || 'http://auth-service:8001',
  measurement: process.env.MEASUREMENT_SERVICE_URL || 'http://measurement-service:8002',
  ai: process.env.AI_SERVICE_URL || 'http://ai-service:8003',
  payment: process.env.PAYMENT_SERVICE_URL || 'http://payment-service:3004',
  notification: process.env.NOTIFICATION_SERVICE_URL || 'http://notification-service:3005',
  video: process.env.VIDEO_SERVICE_URL || 'http://video-service:3006',
  translation: process.env.TRANSLATION_SERVICE_URL || 'http://translation-service:3007',
  data: process.env.DATA_SERVICE_URL || 'http://data-service:3008',
  admin: process.env.ADMIN_SERVICE_URL || 'http://admin-service:3009',
};

const SYSTEM_TOKEN = process.env.SYSTEM_SERVICE_TOKEN || 'system-internal-token';

class ServiceClient {
  constructor(serviceName, timeout = 5000) {
    this.serviceName = serviceName;
    this.baseUrl = SERVICE_ENDPOINTS[serviceName];
    this.client = axios.create({
      baseURL: this.baseUrl,
      timeout,
      headers: {
        'Content-Type': 'application/json',
        'X-Service-Name': process.env.SERVICE_NAME || 'unknown',
        'Authorization': `Bearer ${SYSTEM_TOKEN}`,
      },
    });
  }

  async post(path, data = {}) {
    try {
      const response = await this.client.post(path, data);
      return response.data;
    } catch (error) {
      console.error(`[ServiceClient] ${this.serviceName} 호출 실패:`, error.message);
      return { success: false, error: error.message };
    }
  }
}

const aiClient = new ServiceClient('ai');
const notificationClient = new ServiceClient('notification');

// AI 코칭 요청
async function requestAICoaching(userId, measurements) {
  try {
    console.log(`[AI] 사용자 ${userId}에 대한 AI 코칭 요청`);
    return await aiClient.post('/api/coaching/recommendations', {
      userId,
      measurements: measurements.map(m => ({
        type: m.type, value: m.value, unit: m.unit,
        timestamp: m.timestamp || new Date().toISOString(),
      })),
    });
  } catch (error) {
    console.error('[AI] AI 코칭 요청 실패:', error);
    return { success: false, error: error.message };
  }
}

// 알림 전송
async function sendNotification(userId, type, title, body, data = {}) {
  try {
    console.log(`[Notification] 알림 전송: userId=${userId}, type=${type}`);
    return await notificationClient.post('/api/v1/notifications/send', {
      user_id: userId, type, title, body, data,
    });
  } catch (error) {
    console.error('[Notification] 알림 전송 실패:', error);
    return { success: false, error: error.message };
  }
}

module.exports = {
  ServiceClient, SERVICE_ENDPOINTS,
  requestAICoaching, sendNotification,
  aiClient, notificationClient,
};

