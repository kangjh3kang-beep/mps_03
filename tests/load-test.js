import http from 'k6/http';
import { check, group, sleep } from 'k6';
import { Rate, Trend, Counter, Gauge } from 'k6/metrics';

// Custom metrics
const errorRate = new Rate('errors');
const requestDuration = new Trend('request_duration');
const successCount = new Counter('success_requests');
const activeConnections = new Gauge('active_connections');

// Test configuration
export const options = {
  stages: [
    { duration: '1m', target: 10 },    // Ramp up to 10 users
    { duration: '5m', target: 50 },    // Ramp up to 50 users
    { duration: '10m', target: 100 },  // Ramp up to 100 users
    { duration: '5m', target: 100 },   // Stay at 100 users
    { duration: '5m', target: 50 },    // Ramp down to 50
    { duration: '1m', target: 0 },     // Ramp down to 0
  ],
  thresholds: {
    'http_req_duration': ['p(95)<2000', 'p(99)<3000'],  // P95 < 2s, P99 < 3s
    'http_req_failed': ['rate<0.1'],                      // Error rate < 10%
    'errors': ['rate<0.05'],                               // Custom error rate < 5%
  },
};

const BASE_URL = __ENV.BASE_URL || 'http://localhost:8080';
const API_TOKEN = __ENV.API_TOKEN || 'test-token';

// Test data
const testUsers = [
  { email: 'user1@test.com', password: 'Password123!' },
  { email: 'user2@test.com', password: 'Password123!' },
  { email: 'user3@test.com', password: 'Password123!' },
];

const measurements = [
  { type: 'blood_pressure', systolic: 120, diastolic: 80, pulse: 70 },
  { type: 'blood_pressure', systolic: 125, diastolic: 82, pulse: 72 },
  { type: 'heart_rate', rate: 75, rhythm: 'regular' },
  { type: 'temperature', value: 36.5, unit: 'C' },
  { type: 'weight', value: 70.5, unit: 'kg' },
];

let authToken = '';

export function setup() {
  // One-time setup
  console.log('Starting load test...');
  
  // Try to get auth token
  const loginRes = http.post(`${BASE_URL}/auth/login`, {
    email: testUsers[0].email,
    password: testUsers[0].password,
  });

  if (loginRes.status === 200) {
    authToken = loginRes.json('token');
    console.log(`Got auth token: ${authToken}`);
  }

  return { authToken };
}

export default function (data) {
  const token = data.authToken || API_TOKEN;
  const headers = {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json',
  };

  // Test 1: Authentication Service
  group('Authentication Service', () => {
    group('Login', () => {
      const loginRes = http.post(`${BASE_URL}/auth/login`, {
        email: testUsers[Math.floor(Math.random() * testUsers.length)].email,
        password: 'Password123!',
      });

      check(loginRes, {
        'login status is 200': (r) => r.status === 200,
        'login returns token': (r) => r.json('token') !== undefined,
        'login response time < 1s': (r) => r.timings.duration < 1000,
      });

      errorRate.add(loginRes.status !== 200);
      requestDuration.add(loginRes.timings.duration);
      successCount.add(loginRes.status === 200);
    });

    group('Verify Token', () => {
      const verifyRes = http.get(`${BASE_URL}/auth/verify`, { headers });

      check(verifyRes, {
        'verify status is 200': (r) => r.status === 200,
        'token is valid': (r) => r.json('valid') === true,
      });

      errorRate.add(verifyRes.status !== 200);
      requestDuration.add(verifyRes.timings.duration);
    });
  });

  sleep(1);

  // Test 2: Measurement Service
  group('Measurement Service', () => {
    group('Create Measurement', () => {
      const measurement = measurements[Math.floor(Math.random() * measurements.length)];
      const createRes = http.post(`${BASE_URL}/measurement/create`, measurement, { headers });

      check(createRes, {
        'create measurement status is 201': (r) => r.status === 201,
        'measurement has ID': (r) => r.json('measurementId') !== undefined,
      });

      errorRate.add(createRes.status !== 201);
      requestDuration.add(createRes.timings.duration);
      successCount.add(createRes.status === 201);
    });

    group('List Measurements', () => {
      const listRes = http.get(
        `${BASE_URL}/measurement/list?limit=10&offset=0`,
        { headers }
      );

      check(listRes, {
        'list status is 200': (r) => r.status === 200,
        'list returns array': (r) => Array.isArray(r.json('measurements')),
        'response time < 500ms': (r) => r.timings.duration < 500,
      });

      errorRate.add(listRes.status !== 200);
      requestDuration.add(listRes.timings.duration);
    });

    group('Analyze Measurements', () => {
      const analyzeRes = http.post(
        `${BASE_URL}/measurement/analyze`,
        {
          startDate: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString(),
          endDate: new Date().toISOString(),
          types: ['blood_pressure', 'heart_rate'],
        },
        { headers }
      );

      check(analyzeRes, {
        'analyze status is 200': (r) => r.status === 200,
        'analysis has summary': (r) => r.json('summary') !== undefined,
        'analysis has trends': (r) => r.json('trends') !== undefined,
      });

      errorRate.add(analyzeRes.status !== 200);
      requestDuration.add(analyzeRes.timings.duration);
    });
  });

  sleep(1);

  // Test 3: Payment Service
  group('Payment Service', () => {
    group('Create Payment Intent', () => {
      const intentRes = http.post(
        `${BASE_URL}/payment/intent`,
        {
          amount: 29900,
          currency: 'KRW',
          description: 'Premium Subscription',
        },
        { headers }
      );

      check(intentRes, {
        'intent status is 201': (r) => r.status === 201,
        'intent has secret': (r) => r.json('clientSecret') !== undefined,
      });

      errorRate.add(intentRes.status !== 201);
      requestDuration.add(intentRes.timings.duration);
    });

    group('Get Payment History', () => {
      const historyRes = http.get(`${BASE_URL}/payment/history`, { headers });

      check(historyRes, {
        'history status is 200': (r) => r.status === 200,
        'history returns transactions': (r) => Array.isArray(r.json('transactions')),
      });

      errorRate.add(historyRes.status !== 200);
      requestDuration.add(historyRes.timings.duration);
    });
  });

  sleep(1);

  // Test 4: Notification Service
  group('Notification Service', () => {
    group('Send Notification', () => {
      const notifRes = http.post(
        `${BASE_URL}/notification/send`,
        {
          title: 'Test Notification',
          message: 'This is a performance test notification',
          type: 'test',
        },
        { headers }
      );

      check(notifRes, {
        'send notification status is 200': (r) => r.status === 200,
        'notification has ID': (r) => r.json('notificationId') !== undefined,
      });

      errorRate.add(notifRes.status !== 200);
      requestDuration.add(notifRes.timings.duration);
    });

    group('Get Notifications', () => {
      const listRes = http.get(`${BASE_URL}/notification/list`, { headers });

      check(listRes, {
        'get notifications status is 200': (r) => r.status === 200,
        'notifications is array': (r) => Array.isArray(r.json('notifications')),
      });

      errorRate.add(listRes.status !== 200);
      requestDuration.add(listRes.timings.duration);
    });
  });

  sleep(1);

  // Test 5: Translation Service
  group('Translation Service', () => {
    const texts = [
      'Hello, how are you?',
      'Good morning',
      'Thank you very much',
      'What is your name?',
      'I love Manpasik',
    ];

    group('Translate Text', () => {
      const text = texts[Math.floor(Math.random() * texts.length)];
      const translateRes = http.post(
        `${BASE_URL}/translate/text`,
        {
          text: text,
          sourceLanguage: 'en',
          targetLanguage: 'ko',
        },
        { headers }
      );

      check(translateRes, {
        'translate status is 200': (r) => r.status === 200,
        'translation has text': (r) => r.json('translatedText') !== undefined,
      });

      errorRate.add(translateRes.status !== 200);
      requestDuration.add(translateRes.timings.duration);
    });
  });

  sleep(1);

  // Test 6: AI Service
  group('AI Service', () => {
    group('Analyze Health Data', () => {
      const analysisRes = http.post(
        `${BASE_URL}/ai/analyze`,
        {
          dataType: 'blood_pressure',
          data: [
            { timestamp: new Date().toISOString(), systolic: 120, diastolic: 80 },
            { timestamp: new Date().toISOString(), systolic: 125, diastolic: 82 },
          ],
          period: 7,
        },
        { headers }
      );

      check(analysisRes, {
        'analysis status is 200': (r) => r.status === 200,
        'analysis has recommendations': (r) => r.json('recommendations') !== undefined,
      });

      errorRate.add(analysisRes.status !== 200);
      requestDuration.add(analysisRes.timings.duration);
    });

    group('Get Health Insights', () => {
      const insightsRes = http.get(`${BASE_URL}/ai/insights`, { headers });

      check(insightsRes, {
        'insights status is 200': (r) => r.status === 200,
        'insights is array': (r) => Array.isArray(r.json('insights')),
      });

      errorRate.add(insightsRes.status !== 200);
      requestDuration.add(insightsRes.timings.duration);
    });
  });

  sleep(2);
}

export function handleSummary(data) {
  return {
    'stdout': htmlReport(data),
  };
}

// Simple HTML report
function htmlReport(data) {
  const metrics = data.metrics;
  const timestamp = new Date().toISOString();

  let html = `
    <!DOCTYPE html>
    <html>
    <head>
        <title>K6 Load Test Report</title>
        <style>
            body { font-family: Arial; margin: 20px; }
            h1 { color: #333; }
            table { border-collapse: collapse; width: 100%; margin: 20px 0; }
            th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
            th { background-color: #4CAF50; color: white; }
            .pass { color: green; }
            .fail { color: red; }
        </style>
    </head>
    <body>
        <h1>K6 Load Test Report</h1>
        <p>Generated: ${timestamp}</p>
        
        <h2>Test Results</h2>
        <table>
            <tr>
                <th>Metric</th>
                <th>Value</th>
                <th>Status</th>
            </tr>
  `;

  // Add metrics
  if (metrics.http_reqs) {
    const totalRequests = metrics.http_reqs.value;
    html += `<tr><td>Total Requests</td><td>${totalRequests}</td><td class="pass">✓</td></tr>`;
  }

  if (metrics.http_req_failed) {
    const failedRate = metrics.http_req_failed.value;
    const status = failedRate < 0.1 ? 'pass' : 'fail';
    html += `<tr><td>Failed Rate</td><td>${(failedRate * 100).toFixed(2)}%</td><td class="${status}">✓</td></tr>`;
  }

  if (metrics.http_req_duration) {
    const avg = metrics.http_req_duration.values.avg;
    const p95 = metrics.http_req_duration.values['p(95)'];
    const p99 = metrics.http_req_duration.values['p(99)'];
    
    html += `
        <tr><td>Avg Duration</td><td>${avg.toFixed(2)}ms</td><td>-</td></tr>
        <tr><td>P95 Duration</td><td>${p95.toFixed(2)}ms</td><td>${p95 < 2000 ? 'pass' : 'fail'}</td></tr>
        <tr><td>P99 Duration</td><td>${p99.toFixed(2)}ms</td><td>${p99 < 3000 ? 'pass' : 'fail'}</td></tr>
    `;
  }

  html += `
        </table>
        
        <h2>Summary</h2>
        <p>Load test completed successfully. Check thresholds above for pass/fail status.</p>
    </body>
    </html>
  `;

  return html;
}
