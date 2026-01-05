const express = require('express');
const jwt = require('jsonwebtoken');
const axios = require('axios');
const { Pool } = require('pg');
const crypto = require('crypto');

// 서비스 간 통신 클라이언트
const { sendNotification } = require('../../shared/service-client');

const app = express();
const port = process.env.PORT || 3006;

// ============================================
// Configuration
// ============================================
const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'password',
  host: process.env.DB_HOST || 'db',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'mps_video',
});

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';

// Agora Configuration
const AGORA_APP_ID = process.env.AGORA_APP_ID || 'demo-app-id';
const AGORA_APP_CERTIFICATE = process.env.AGORA_APP_CERTIFICATE || 'demo-app-certificate';

// ============================================
// Middleware
// ============================================
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Auth Middleware
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: '토큰 없음' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) return res.status(403).json({ error: '토큰 검증 실패' });
    req.user = user;
    next();
  });
};

// ============================================
// Database Initialization
// ============================================
const initDatabase = async () => {
  const client = await pool.connect();
  try {
    await client.query(`
      CREATE TABLE IF NOT EXISTS video_sessions (
        id SERIAL PRIMARY KEY,
        session_id VARCHAR(255) UNIQUE NOT NULL,
        channel_name VARCHAR(100) UNIQUE,
        initiator_id VARCHAR(255) NOT NULL,
        recipient_id VARCHAR(255),
        type VARCHAR(50),
        status VARCHAR(50),
        started_at TIMESTAMP,
        ended_at TIMESTAMP,
        duration_seconds INTEGER,
        metadata JSONB,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS video_recordings (
        id SERIAL PRIMARY KEY,
        session_id VARCHAR(255) UNIQUE,
        recording_id VARCHAR(255) UNIQUE,
        storage_url VARCHAR(500),
        file_size BIGINT,
        duration_seconds INTEGER,
        status VARCHAR(50),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (session_id) REFERENCES video_sessions(session_id)
      );

      CREATE TABLE IF NOT EXISTS video_prescriptions (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) NOT NULL,
        doctor_id VARCHAR(255) NOT NULL,
        session_id VARCHAR(255),
        title VARCHAR(255),
        description TEXT,
        instructions TEXT,
        medication_list JSONB,
        follow_up_date DATE,
        status VARCHAR(50),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (session_id) REFERENCES video_sessions(session_id)
      );

      CREATE TABLE IF NOT EXISTS video_participants (
        id SERIAL PRIMARY KEY,
        session_id VARCHAR(255) NOT NULL,
        user_id VARCHAR(255) NOT NULL,
        role VARCHAR(50),
        joined_at TIMESTAMP,
        left_at TIMESTAMP,
        duration_seconds INTEGER,
        FOREIGN KEY (session_id) REFERENCES video_sessions(session_id)
      );

      CREATE TABLE IF NOT EXISTS video_chat_messages (
        id SERIAL PRIMARY KEY,
        session_id VARCHAR(255) NOT NULL,
        user_id VARCHAR(255) NOT NULL,
        message TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (session_id) REFERENCES video_sessions(session_id)
      );

      CREATE INDEX IF NOT EXISTS idx_video_sessions_initiator ON video_sessions(initiator_id);
      CREATE INDEX IF NOT EXISTS idx_video_sessions_status ON video_sessions(status);
      CREATE INDEX IF NOT EXISTS idx_video_participants_session ON video_participants(session_id);
    `);
    console.log('Database initialized successfully');
  } finally {
    client.release();
  }
};

// ============================================
// Helper Functions
// ============================================

// Generate Agora token
const generateAgoraToken = (channelName, userId) => {
  // RtcTokenBuilder would be used in production
  // This is a simplified version
  const timestamp = Math.floor(Date.now() / 1000) + 3600; // 1 hour validity
  
  // In production, use proper RTC token generation
  // For now, return a mock token
  return `${AGORA_APP_ID}_${channelName}_${userId}_${timestamp}`;
};

// ============================================
// Health Check
// ============================================
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    service: 'video-service',
    timestamp: new Date().toISOString(),
  });
});

// ============================================
// Video Sessions
// ============================================

// Create video session
app.post('/api/v1/video-sessions', authenticateToken, async (req, res) => {
  try {
    const { recipient_id, type = 'consultation', metadata } = req.body;

    const sessionId = crypto.randomBytes(16).toString('hex');
    const channelName = `mps-${sessionId}`;

    const result = await pool.query(
      `INSERT INTO video_sessions 
       (session_id, channel_name, initiator_id, recipient_id, type, status, metadata)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
      [sessionId, channelName, req.user.id, recipient_id, type, 'pending', JSON.stringify(metadata || {})]
    );

    // Generate tokens
    const initiatorToken = generateAgoraToken(channelName, req.user.id);
    const recipientToken = generateAgoraToken(channelName, recipient_id);

    res.status(201).json({
      success: true,
      message: '비디오 세션이 생성되었습니다',
      data: {
        sessionId: result.rows[0].session_id,
        channelName: result.rows[0].channel_name,
        initiatorToken,
        recipientToken,
        agoraAppId: AGORA_APP_ID,
      },
    });
  } catch (err) {
    console.error('Error creating video session:', err);
    res.status(500).json({ error: '비디오 세션 생성 실패' });
  }
});

// Get session details
app.get('/api/v1/video-sessions/:id', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT * FROM video_sessions 
       WHERE session_id = $1 AND (initiator_id = $2 OR recipient_id = $2)`,
      [req.params.id, req.user.id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: '세션을 찾을 수 없습니다' });
    }

    const session = result.rows[0];

    // Get participants
    const participantsResult = await pool.query(
      'SELECT * FROM video_participants WHERE session_id = $1',
      [req.params.id]
    );

    res.json({
      success: true,
      data: {
        ...session,
        participants: participantsResult.rows,
      },
    });
  } catch (err) {
    console.error('Error fetching session:', err);
    res.status(500).json({ error: '세션 조회 실패' });
  }
});

// Start session
app.post('/api/v1/video-sessions/:id/start', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      `UPDATE video_sessions 
       SET status = $1, started_at = NOW()
       WHERE session_id = $2 AND (initiator_id = $3 OR recipient_id = $3)
       RETURNING *`,
      ['active', req.params.id, req.user.id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: '세션을 찾을 수 없습니다' });
    }

    // Record participant
    await pool.query(
      `INSERT INTO video_participants (session_id, user_id, role, joined_at)
       VALUES ($1, $2, $3, NOW())`,
      [req.params.id, req.user.id, 'participant']
    );

    // 🔗 알림 서비스 연동 - 화상상담 시작 알림
    const session = result.rows[0];
    const recipientId = session.initiator_id === req.user.id 
      ? session.recipient_id 
      : session.initiator_id;
    
    sendNotification(
      recipientId,
      'video',
      '📹 화상상담 시작',
      '화상상담이 시작되었습니다. 지금 참여하세요.',
      { sessionId: req.params.id, channelName: session.channel_name }
    ).catch(err => console.error('[Video→Notification] 알림 전송 실패:', err));

    res.json({
      success: true,
      message: '세션이 시작되었습니다',
      data: result.rows[0],
    });
  } catch (err) {
    console.error('Error starting session:', err);
    res.status(500).json({ error: '세션 시작 실패' });
  }
});

// End session
app.post('/api/v1/video-sessions/:id/end', authenticateToken, async (req, res) => {
  try {
    const sessionResult = await pool.query(
      'SELECT started_at FROM video_sessions WHERE session_id = $1',
      [req.params.id]
    );

    if (sessionResult.rowCount === 0) {
      return res.status(404).json({ error: '세션을 찾을 수 없습니다' });
    }

    const startedAt = sessionResult.rows[0].started_at;
    const duration = startedAt ? Math.floor((Date.now() - new Date(startedAt).getTime()) / 1000) : 0;

    const result = await pool.query(
      `UPDATE video_sessions 
       SET status = $1, ended_at = NOW(), duration_seconds = $2
       WHERE session_id = $3
       RETURNING *`,
      ['ended', duration, req.params.id]
    );

    // Update participant
    await pool.query(
      'UPDATE video_participants SET left_at = NOW() WHERE session_id = $1 AND user_id = $2',
      [req.params.id, req.user.id]
    );

    // 🔗 알림 서비스 연동 - 화상상담 종료 알림
    const session = result.rows[0];
    const recipientId = session.initiator_id === req.user.id 
      ? session.recipient_id 
      : session.initiator_id;
    
    const durationMin = Math.floor(duration / 60);
    sendNotification(
      recipientId,
      'video',
      '📹 화상상담 종료',
      `화상상담이 종료되었습니다. (${durationMin}분)`,
      { sessionId: req.params.id, duration }
    ).catch(err => console.error('[Video→Notification] 알림 전송 실패:', err));

    res.json({
      success: true,
      message: '세션이 종료되었습니다',
      data: result.rows[0],
    });
  } catch (err) {
    console.error('Error ending session:', err);
    res.status(500).json({ error: '세션 종료 실패' });
  }
});

// List sessions
app.get('/api/v1/video-sessions', authenticateToken, async (req, res) => {
  try {
    const { status, type, limit = 50, offset = 0 } = req.query;

    let query = `SELECT * FROM video_sessions 
                 WHERE initiator_id = $1 OR recipient_id = $1`;
    const params = [req.user.id];

    if (status) {
      query += ` AND status = $${params.length + 1}`;
      params.push(status);
    }
    if (type) {
      query += ` AND type = $${params.length + 1}`;
      params.push(type);
    }

    query += ` ORDER BY created_at DESC LIMIT $${params.length + 1} OFFSET $${params.length + 2}`;
    params.push(limit, offset);

    const result = await pool.query(query, params);

    res.json({
      success: true,
      data: result.rows,
      count: result.rows.length,
    });
  } catch (err) {
    console.error('Error fetching sessions:', err);
    res.status(500).json({ error: '세션 조회 실패' });
  }
});

// ============================================
// Prescriptions
// ============================================

// Create prescription from session
app.post('/api/v1/prescriptions', authenticateToken, async (req, res) => {
  try {
    const { user_id, session_id, title, description, instructions, medications, follow_up_date } = req.body;

    const result = await pool.query(
      `INSERT INTO video_prescriptions 
       (user_id, doctor_id, session_id, title, description, instructions, medication_list, follow_up_date, status)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
       RETURNING *`,
      [user_id, req.user.id, session_id, title, description, instructions, JSON.stringify(medications || []), follow_up_date, 'active']
    );

    res.status(201).json({
      success: true,
      message: '처방이 생성되었습니다',
      data: result.rows[0],
    });
  } catch (err) {
    console.error('Error creating prescription:', err);
    res.status(500).json({ error: '처방 생성 실패' });
  }
});

// Get prescriptions
app.get('/api/v1/prescriptions', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM video_prescriptions WHERE user_id = $1 OR doctor_id = $1 ORDER BY created_at DESC LIMIT 50',
      [req.user.id]
    );

    res.json({
      success: true,
      data: result.rows,
      count: result.rows.length,
    });
  } catch (err) {
    console.error('Error fetching prescriptions:', err);
    res.status(500).json({ error: '처방 조회 실패' });
  }
});

// ============================================
// Chat Messages
// ============================================

// Send message
app.post('/api/v1/video-sessions/:id/messages', authenticateToken, async (req, res) => {
  try {
    const { message } = req.body;

    const result = await pool.query(
      `INSERT INTO video_chat_messages (session_id, user_id, message)
       VALUES ($1, $2, $3)
       RETURNING *`,
      [req.params.id, req.user.id, message]
    );

    res.status(201).json({
      success: true,
      message: '메시지가 전송되었습니다',
      data: result.rows[0],
    });
  } catch (err) {
    console.error('Error sending message:', err);
    res.status(500).json({ error: '메시지 전송 실패' });
  }
});

// Get messages
app.get('/api/v1/video-sessions/:id/messages', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM video_chat_messages WHERE session_id = $1 ORDER BY created_at ASC LIMIT 100',
      [req.params.id]
    );

    res.json({
      success: true,
      data: result.rows,
      count: result.rows.length,
    });
  } catch (err) {
    console.error('Error fetching messages:', err);
    res.status(500).json({ error: '메시지 조회 실패' });
  }
});

// ============================================
// Server Startup
// ============================================
app.listen(port, async () => {
  await initDatabase();
  console.log(`Video Service listening on port ${port}`);
});

module.exports = app;
