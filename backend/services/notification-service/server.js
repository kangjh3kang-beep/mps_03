const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const jwt = require('jsonwebtoken');
const admin = require('firebase-admin');
const { Pool } = require('pg');

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  },
});

const port = process.env.PORT || 3005;

// ============================================
// Configuration
// ============================================
const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'password',
  host: process.env.DB_HOST || 'db',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'mps_notification',
});

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';

// Firebase Admin initialization
try {
  admin.initializeApp({
    credential: admin.credential.cert(JSON.parse(process.env.FIREBASE_CONFIG || '{}') || {}),
    databaseURL: process.env.FIREBASE_DB_URL || 'https://manpasik.firebaseio.com',
  });
} catch (err) {
  console.warn('Firebase initialization skipped:', err.message);
}

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
      CREATE TABLE IF NOT EXISTS notifications (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) NOT NULL,
        title VARCHAR(255),
        body TEXT,
        type VARCHAR(50),
        data JSONB,
        is_read BOOLEAN DEFAULT false,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        read_at TIMESTAMP,
        expires_at TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS notification_preferences (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) UNIQUE NOT NULL,
        push_enabled BOOLEAN DEFAULT true,
        email_enabled BOOLEAN DEFAULT true,
        sms_enabled BOOLEAN DEFAULT false,
        in_app_enabled BOOLEAN DEFAULT true,
        quiet_hours_start TIME,
        quiet_hours_end TIME,
        categories JSONB DEFAULT '{"measurement": true, "coaching": true, "community": true, "system": true}',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS fcm_tokens (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) NOT NULL,
        device_id VARCHAR(255),
        fcm_token TEXT UNIQUE,
        device_type VARCHAR(50),
        is_active BOOLEAN DEFAULT true,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(user_id, device_id)
      );

      CREATE TABLE IF NOT EXISTS notification_templates (
        id SERIAL PRIMARY KEY,
        template_name VARCHAR(100) UNIQUE,
        title_template VARCHAR(255),
        body_template TEXT,
        icon_url VARCHAR(500),
        category VARCHAR(50),
        is_active BOOLEAN DEFAULT true,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
      CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at);
      CREATE INDEX IF NOT EXISTS idx_fcm_tokens_user_id ON fcm_tokens(user_id);
    `);
    console.log('Database initialized successfully');
  } finally {
    client.release();
  }
};

// ============================================
// Health Check
// ============================================
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    service: 'notification-service',
    timestamp: new Date().toISOString(),
  });
});

// ============================================
// WebSocket Events
// ============================================
io.on('connection', (socket) => {
  console.log('User connected:', socket.id);

  // User joins room with their ID
  socket.on('register', (userId) => {
    socket.join(userId);
    console.log(`User ${userId} registered for notifications`);
  });

  // User leaves
  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);
  });
});

// ============================================
// Push Notifications
// ============================================

// Send push notification
app.post('/api/v1/notifications/send', authenticateToken, async (req, res) => {
  try {
    const { user_id, title, body, type, data } = req.body;

    // Get FCM tokens for user
    const tokensResult = await pool.query(
      'SELECT fcm_token FROM fcm_tokens WHERE user_id = $1 AND is_active = true',
      [user_id]
    );

    // Send to all devices
    const messages = tokensResult.rows.map(row => ({
      token: row.fcm_token,
      notification: { title, body },
      data: data || {},
    }));

    if (messages.length > 0) {
      const response = await admin.messaging().sendAll(messages);
      console.log(`Successfully sent ${response.successCount} messages`);
    }

    // Save to database
    const result = await pool.query(
      `INSERT INTO notifications (user_id, title, body, type, data)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
      [user_id, title, body, type, JSON.stringify(data || {})]
    );

    // Send via WebSocket to connected clients
    io.to(user_id).emit('notification', {
      id: result.rows[0].id,
      title,
      body,
      type,
      data,
      createdAt: result.rows[0].created_at,
    });

    res.status(201).json({
      success: true,
      message: '알림이 전송되었습니다',
      data: result.rows[0],
    });
  } catch (err) {
    console.error('Error sending notification:', err);
    res.status(500).json({ error: '알림 전송 실패' });
  }
});

// Broadcast notification
app.post('/api/v1/notifications/broadcast', authenticateToken, async (req, res) => {
  try {
    const { title, body, type, data, targetGroup } = req.body;

    // Get all users or specific group
    let userIds = [];
    if (targetGroup === 'all') {
      const result = await pool.query(
        'SELECT DISTINCT user_id FROM fcm_tokens WHERE is_active = true'
      );
      userIds = result.rows.map(row => row.user_id);
    } else {
      // TODO: Filter by targetGroup if needed
    }

    // Send to all users
    const results = [];
    for (const userId of userIds) {
      const result = await pool.query(
        `INSERT INTO notifications (user_id, title, body, type, data)
         VALUES ($1, $2, $3, $4, $5)
         RETURNING *`,
        [userId, title, body, type, JSON.stringify(data || {})]
      );
      results.push(result.rows[0]);

      // Send via WebSocket
      io.to(userId).emit('notification', {
        id: result.rows[0].id,
        title,
        body,
        type,
        data,
        createdAt: result.rows[0].created_at,
      });
    }

    res.status(201).json({
      success: true,
      message: `${userIds.length}명에게 알림이 전송되었습니다`,
      sentCount: userIds.length,
    });
  } catch (err) {
    console.error('Error broadcasting notification:', err);
    res.status(500).json({ error: '브로드캐스트 실패' });
  }
});

// Get notifications
app.get('/api/v1/notifications', authenticateToken, async (req, res) => {
  try {
    const { limit = 50, offset = 0, unread_only = false } = req.query;

    let query = 'SELECT * FROM notifications WHERE user_id = $1';
    const params = [req.user.id];

    if (unread_only === 'true') {
      query += ' AND is_read = false';
    }

    query += ' ORDER BY created_at DESC LIMIT $' + (params.length + 1) + ' OFFSET $' + (params.length + 2);
    params.push(limit, offset);

    const result = await pool.query(query, params);

    res.json({
      success: true,
      data: result.rows,
      count: result.rows.length,
    });
  } catch (err) {
    console.error('Error fetching notifications:', err);
    res.status(500).json({ error: '알림 조회 실패' });
  }
});

// Mark notification as read
app.put('/api/v1/notifications/:id/read', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      'UPDATE notifications SET is_read = true, read_at = NOW() WHERE id = $1 AND user_id = $2 RETURNING *',
      [req.params.id, req.user.id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: '알림을 찾을 수 없습니다' });
    }

    res.json({
      success: true,
      message: '알림이 읽음으로 표시되었습니다',
      data: result.rows[0],
    });
  } catch (err) {
    console.error('Error marking notification as read:', err);
    res.status(500).json({ error: '알림 업데이트 실패' });
  }
});

// Delete notification
app.delete('/api/v1/notifications/:id', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      'DELETE FROM notifications WHERE id = $1 AND user_id = $2 RETURNING *',
      [req.params.id, req.user.id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: '알림을 찾을 수 없습니다' });
    }

    res.json({
      success: true,
      message: '알림이 삭제되었습니다',
    });
  } catch (err) {
    console.error('Error deleting notification:', err);
    res.status(500).json({ error: '알림 삭제 실패' });
  }
});

// ============================================
// FCM Token Management
// ============================================

// Register FCM token
app.post('/api/v1/fcm-tokens', authenticateToken, async (req, res) => {
  try {
    const { fcm_token, device_id, device_type } = req.body;

    const result = await pool.query(
      `INSERT INTO fcm_tokens (user_id, device_id, fcm_token, device_type)
       VALUES ($1, $2, $3, $4)
       ON CONFLICT (user_id, device_id) 
       DO UPDATE SET fcm_token = EXCLUDED.fcm_token, updated_at = NOW()
       RETURNING *`,
      [req.user.id, device_id, fcm_token, device_type]
    );

    res.status(201).json({
      success: true,
      message: 'FCM 토큰이 등록되었습니다',
      data: result.rows[0],
    });
  } catch (err) {
    console.error('Error registering FCM token:', err);
    res.status(500).json({ error: 'FCM 토큰 등록 실패' });
  }
});

// ============================================
// Notification Preferences
// ============================================

// Get preferences
app.get('/api/v1/notification-preferences', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM notification_preferences WHERE user_id = $1',
      [req.user.id]
    );

    if (result.rowCount === 0) {
      // Create default preferences
      const defaultResult = await pool.query(
        `INSERT INTO notification_preferences (user_id)
         VALUES ($1)
         RETURNING *`,
        [req.user.id]
      );
      return res.json({
        success: true,
        data: defaultResult.rows[0],
      });
    }

    res.json({
      success: true,
      data: result.rows[0],
    });
  } catch (err) {
    console.error('Error fetching preferences:', err);
    res.status(500).json({ error: '설정 조회 실패' });
  }
});

// Update preferences
app.put('/api/v1/notification-preferences', authenticateToken, async (req, res) => {
  try {
    const { push_enabled, email_enabled, sms_enabled, in_app_enabled, quiet_hours_start, quiet_hours_end, categories } = req.body;

    const result = await pool.query(
      `UPDATE notification_preferences 
       SET push_enabled = COALESCE($1, push_enabled),
           email_enabled = COALESCE($2, email_enabled),
           sms_enabled = COALESCE($3, sms_enabled),
           in_app_enabled = COALESCE($4, in_app_enabled),
           quiet_hours_start = COALESCE($5, quiet_hours_start),
           quiet_hours_end = COALESCE($6, quiet_hours_end),
           categories = COALESCE($7, categories),
           updated_at = NOW()
       WHERE user_id = $8
       RETURNING *`,
      [push_enabled, email_enabled, sms_enabled, in_app_enabled, quiet_hours_start, quiet_hours_end, categories ? JSON.stringify(categories) : null, req.user.id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: '설정을 찾을 수 없습니다' });
    }

    res.json({
      success: true,
      message: '설정이 업데이트되었습니다',
      data: result.rows[0],
    });
  } catch (err) {
    console.error('Error updating preferences:', err);
    res.status(500).json({ error: '설정 업데이트 실패' });
  }
});

// ============================================
// Server Startup
// ============================================
server.listen(port, async () => {
  await initDatabase();
  console.log(`Notification Service listening on port ${port}`);
});

module.exports = { app, io };
