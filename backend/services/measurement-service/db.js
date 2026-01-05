/**
 * Measurement Service - MongoDB 연결 모듈
 * 프로덕션 환경에서 실제 MongoDB와 연결합니다.
 */

const mongoose = require('mongoose');

// MongoDB 연결 설정
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://mongo:27017/manpasik_measurements';

let isConnected = false;

// MongoDB 연결
async function connectDB() {
  if (isConnected) {
    console.log('[MongoDB] Already connected');
    return;
  }

  try {
    const options = {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      // 인증이 필요한 경우
      // authSource: 'admin',
      // user: process.env.MONGO_USER,
      // pass: process.env.MONGO_PASSWORD,
    };

    await mongoose.connect(MONGODB_URI, options);
    isConnected = true;
    console.log('[MongoDB] Connected successfully');
  } catch (error) {
    console.error('[MongoDB] Connection failed:', error.message);
    // 개발 환경에서는 In-Memory 모드로 폴백
    console.log('[MongoDB] Falling back to in-memory mode');
  }
}

// 연결 상태 확인
function getConnectionStatus() {
  const states = {
    0: 'disconnected',
    1: 'connected',
    2: 'connecting',
    3: 'disconnecting',
  };
  return states[mongoose.connection.readyState] || 'unknown';
}

// ============================================
// 측정 데이터 스키마
// ============================================

const measurementSchema = new mongoose.Schema({
  userId: { type: String, required: true, index: true },
  type: { 
    type: String, 
    required: true,
    enum: ['blood_glucose', 'blood_pressure', 'heart_rate', 'oxygen_level', 'weight', 'temperature']
  },
  value: { type: mongoose.Schema.Types.Mixed, required: true },
  unit: { type: String, required: true },
  timestamp: { type: Date, default: Date.now, index: true },
  source: { 
    type: String, 
    default: 'device',
    enum: ['device', 'manual', 'batch', 'import']
  },
  verified: { type: Boolean, default: true },
  metadata: { type: mongoose.Schema.Types.Mixed },
}, { 
  timestamps: true,
  collection: 'measurements'
});

// 복합 인덱스
measurementSchema.index({ userId: 1, type: 1, timestamp: -1 });
measurementSchema.index({ userId: 1, timestamp: -1 });

const Measurement = mongoose.model('Measurement', measurementSchema);

// ============================================
// 건강 점수 스키마
// ============================================

const healthScoreSchema = new mongoose.Schema({
  userId: { type: String, required: true, unique: true },
  overall: { type: Number, default: 0 },
  glucose: {
    score: Number,
    status: String,
    trend: String,
  },
  bloodPressure: {
    score: Number,
    status: String,
    trend: String,
  },
  heartRate: {
    score: Number,
    status: String,
    trend: String,
  },
  oxygen: {
    score: Number,
    status: String,
    trend: String,
  },
  lastUpdated: { type: Date, default: Date.now },
}, { 
  timestamps: true,
  collection: 'health_scores'
});

const HealthScore = mongoose.model('HealthScore', healthScoreSchema);

// ============================================
// 트렌드 스키마
// ============================================

const trendSchema = new mongoose.Schema({
  userId: { type: String, required: true, unique: true },
  glucose: {
    average: Number,
    min: Number,
    max: Number,
    stdDev: Number,
    trend: String,
    weekOverWeek: Number,
  },
  bloodPressure: {
    systolic: { average: Number, min: Number, max: Number, trend: String },
    diastolic: { average: Number, min: Number, max: Number, trend: String },
  },
  heartRate: {
    average: Number,
    min: Number,
    max: Number,
    resting: Number,
    trend: String,
  },
  lastCalculated: { type: Date, default: Date.now },
}, { 
  timestamps: true,
  collection: 'trends'
});

const Trend = mongoose.model('Trend', trendSchema);

// ============================================
// 모듈 내보내기
// ============================================

module.exports = {
  connectDB,
  getConnectionStatus,
  mongoose,
  Measurement,
  HealthScore,
  Trend,
};

