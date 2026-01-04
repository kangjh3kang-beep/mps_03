const express = require('express');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const { Pool } = require('pg');

const app = express();
const port = process.env.PORT || 3008;

// ============================================
// Configuration
// ============================================
const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'password',
  host: process.env.DB_HOST || 'db',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'mps_data',
});

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';

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
      CREATE TABLE IF NOT EXISTS data_blocks (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) NOT NULL,
        block_hash VARCHAR(255) UNIQUE,
        previous_hash VARCHAR(255),
        data JSONB,
        timestamp BIGINT,
        signature VARCHAR(512),
        is_verified BOOLEAN DEFAULT false,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS data_integrity_checks (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) NOT NULL,
        data_id INTEGER,
        check_type VARCHAR(50),
        result BOOLEAN,
        details TEXT,
        checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (data_id) REFERENCES data_blocks(id)
      );

      CREATE TABLE IF NOT EXISTS audit_logs (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) NOT NULL,
        action VARCHAR(100),
        resource_type VARCHAR(100),
        resource_id VARCHAR(255),
        changes JSONB,
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        ip_address VARCHAR(45),
        user_agent TEXT
      );

      CREATE TABLE IF NOT EXISTS data_exports (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) NOT NULL,
        export_type VARCHAR(50),
        format VARCHAR(50),
        file_path VARCHAR(500),
        file_size BIGINT,
        record_count INTEGER,
        status VARCHAR(50),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        completed_at TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS data_backups (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) NOT NULL,
        backup_type VARCHAR(50),
        backup_location VARCHAR(500),
        backup_size BIGINT,
        record_count INTEGER,
        status VARCHAR(50),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        restored_at TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS encryption_keys (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) UNIQUE NOT NULL,
        key_version INTEGER,
        encrypted_key TEXT,
        public_key TEXT,
        key_rotation_date TIMESTAMP,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS data_access_logs (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) NOT NULL,
        accessed_by VARCHAR(255),
        data_type VARCHAR(100),
        access_type VARCHAR(50),
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        ip_address VARCHAR(45)
      );

      CREATE INDEX IF NOT EXISTS idx_data_blocks_user_id ON data_blocks(user_id);
      CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id ON audit_logs(user_id);
      CREATE INDEX IF NOT EXISTS idx_audit_logs_timestamp ON audit_logs(timestamp);
      CREATE INDEX IF NOT EXISTS idx_data_access_logs_user_id ON data_access_logs(user_id);
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
    service: 'data-service',
    timestamp: new Date().toISOString(),
  });
});

// ============================================
// Blockchain/Hash Chain Functions
// ============================================

// Calculate SHA-256 hash
const calculateHash = (data) => {
  return crypto.createHash('sha256').update(JSON.stringify(data)).digest('hex');
};

// Sign data
const signData = (data, secretKey) => {
  const hmac = crypto.createHmac('sha256', secretKey);
  return hmac.update(JSON.stringify(data)).digest('hex');
};

// ============================================
// Data Integrity
// ============================================

// Store data with hash chain
app.post('/api/v1/data', authenticateToken, async (req, res) => {
  try {
    const { data, dataType } = req.body;

    // Get previous block
    const prevResult = await pool.query(
      'SELECT block_hash FROM data_blocks WHERE user_id = $1 ORDER BY created_at DESC LIMIT 1',
      [req.user.id]
    );

    const previousHash = prevResult.rowCount > 0 ? prevResult.rows[0].block_hash : '0';
    const timestamp = Date.now();

    // Calculate hash
    const blockData = { ...data, timestamp };
    const blockHash = calculateHash(blockData);
    const signature = signData(blockData, JWT_SECRET);

    // Store data
    const result = await pool.query(
      `INSERT INTO data_blocks 
       (user_id, block_hash, previous_hash, data, timestamp, signature, is_verified)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
      [req.user.id, blockHash, previousHash, JSON.stringify(blockData), timestamp, signature, true]
    );

    // Log audit
    await logAudit(req.user.id, 'CREATE', 'DATA_BLOCK', result.rows[0].id, null, req);

    res.status(201).json({
      success: true,
      message: '데이터가 저장되었습니다',
      data: {
        id: result.rows[0].id,
        blockHash: result.rows[0].block_hash,
        previousHash: result.rows[0].previous_hash,
        timestamp: result.rows[0].timestamp,
        isVerified: result.rows[0].is_verified,
      },
    });
  } catch (err) {
    console.error('Error storing data:', err);
    res.status(500).json({ error: '데이터 저장 실패' });
  }
});

// Verify data integrity
app.post('/api/v1/data/:id/verify', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;

    // Get data block
    const result = await pool.query(
      'SELECT * FROM data_blocks WHERE id = $1 AND user_id = $2',
      [id, req.user.id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: '데이터 블록을 찾을 수 없습니다' });
    }

    const block = result.rows[0];
    const calculatedHash = calculateHash({ ...block.data, timestamp: block.timestamp });
    const isValid = calculatedHash === block.block_hash;

    // Check signature
    const calculatedSignature = signData({ ...block.data, timestamp: block.timestamp }, JWT_SECRET);
    const signatureValid = calculatedSignature === block.signature;

    // Record check
    await pool.query(
      `INSERT INTO data_integrity_checks (user_id, data_id, check_type, result, details)
       VALUES ($1, $2, $3, $4, $5)`,
      [req.user.id, id, 'hash_verification', isValid && signatureValid, JSON.stringify({
        hashValid: isValid,
        signatureValid: signatureValid,
        expectedHash: calculatedHash,
        storedHash: block.block_hash,
      })]
    );

    res.json({
      success: true,
      isValid: isValid && signatureValid,
      details: {
        hashMatch: isValid,
        signatureMatch: signatureValid,
        timestamp: block.timestamp,
      },
    });
  } catch (err) {
    console.error('Error verifying data:', err);
    res.status(500).json({ error: '검증 실패' });
  }
});

// Get data
app.get('/api/v1/data/:id', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM data_blocks WHERE id = $1 AND user_id = $2',
      [req.params.id, req.user.id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: '데이터를 찾을 수 없습니다' });
    }

    // Log access
    await logDataAccess(req.user.id, req.user.id, 'DATA_BLOCK', 'READ', req);

    res.json({
      success: true,
      data: result.rows[0],
    });
  } catch (err) {
    console.error('Error fetching data:', err);
    res.status(500).json({ error: '데이터 조회 실패' });
  }
});

// List data blocks
app.get('/api/v1/data', authenticateToken, async (req, res) => {
  try {
    const { limit = 50, offset = 0 } = req.query;

    const result = await pool.query(
      'SELECT * FROM data_blocks WHERE user_id = $1 ORDER BY created_at DESC LIMIT $2 OFFSET $3',
      [req.user.id, limit, offset]
    );

    res.json({
      success: true,
      data: result.rows,
      count: result.rows.length,
    });
  } catch (err) {
    console.error('Error fetching data:', err);
    res.status(500).json({ error: '데이터 조회 실패' });
  }
});

// ============================================
// Audit Logs
// ============================================

// Get audit logs
app.get('/api/v1/audit-logs', authenticateToken, async (req, res) => {
  try {
    const { limit = 100, offset = 0 } = req.query;

    const result = await pool.query(
      'SELECT * FROM audit_logs WHERE user_id = $1 ORDER BY timestamp DESC LIMIT $2 OFFSET $3',
      [req.user.id, limit, offset]
    );

    res.json({
      success: true,
      data: result.rows,
      count: result.rows.length,
    });
  } catch (err) {
    console.error('Error fetching audit logs:', err);
    res.status(500).json({ error: '감사 로그 조회 실패' });
  }
});

// ============================================
// Data Export
// ============================================

// Export data
app.post('/api/v1/data/export', authenticateToken, async (req, res) => {
  try {
    const { format = 'json', exportType = 'all' } = req.body;

    // Get data
    const dataResult = await pool.query(
      'SELECT * FROM data_blocks WHERE user_id = $1 ORDER BY created_at ASC',
      [req.user.id]
    );

    const exportData = dataResult.rows;
    const recordCount = exportData.length;

    // Create export record
    const result = await pool.query(
      `INSERT INTO data_exports 
       (user_id, export_type, format, record_count, status)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
      [req.user.id, exportType, format, recordCount, 'completed']
    );

    res.status(201).json({
      success: true,
      message: '데이터 내보내기가 완료되었습니다',
      data: {
        exportId: result.rows[0].id,
        format: result.rows[0].format,
        recordCount: result.rows[0].record_count,
        createdAt: result.rows[0].created_at,
        exportData: exportData,
      },
    });
  } catch (err) {
    console.error('Error exporting data:', err);
    res.status(500).json({ error: '데이터 내보내기 실패' });
  }
});

// ============================================
// Data Backup
// ============================================

// Create backup
app.post('/api/v1/data/backup', authenticateToken, async (req, res) => {
  try {
    const backupType = req.body.backupType || 'full';

    // Get all user data
    const dataResult = await pool.query(
      'SELECT COUNT(*) as count FROM data_blocks WHERE user_id = $1',
      [req.user.id]
    );

    const recordCount = dataResult.rows[0].count;

    // Create backup record
    const result = await pool.query(
      `INSERT INTO data_backups 
       (user_id, backup_type, backup_location, record_count, status)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
      [req.user.id, backupType, `/backups/${req.user.id}/${Date.now()}`, recordCount, 'completed']
    );

    res.status(201).json({
      success: true,
      message: '백업이 생성되었습니다',
      data: {
        backupId: result.rows[0].id,
        location: result.rows[0].backup_location,
        recordCount: result.rows[0].record_count,
        createdAt: result.rows[0].created_at,
      },
    });
  } catch (err) {
    console.error('Error creating backup:', err);
    res.status(500).json({ error: '백업 생성 실패' });
  }
});

// ============================================
// Encryption Key Management
// ============================================

// Get or create encryption key
app.get('/api/v1/encryption-key', authenticateToken, async (req, res) => {
  try {
    let result = await pool.query(
      'SELECT * FROM encryption_keys WHERE user_id = $1',
      [req.user.id]
    );

    if (result.rowCount === 0) {
      // Generate new key pair
      const { publicKey, privateKey } = crypto.generateKeyPairSync('rsa', {
        modulusLength: 2048,
      });

      const publicKeyStr = publicKey.export({ type: 'spki', format: 'pem' });
      const encryptedKey = crypto.publicEncrypt(publicKey, Buffer.from(JWT_SECRET)).toString('hex');

      result = await pool.query(
        `INSERT INTO encryption_keys 
         (user_id, key_version, encrypted_key, public_key, key_rotation_date)
         VALUES ($1, $2, $3, $4, NOW())
         RETURNING *`,
        [req.user.id, 1, encryptedKey, publicKeyStr]
      );
    }

    res.json({
      success: true,
      data: {
        keyVersion: result.rows[0].key_version,
        publicKey: result.rows[0].public_key,
        keyRotationDate: result.rows[0].key_rotation_date,
      },
    });
  } catch (err) {
    console.error('Error fetching encryption key:', err);
    res.status(500).json({ error: '암호화 키 조회 실패' });
  }
});

// ============================================
// Helper Functions
// ============================================

const logAudit = async (userId, action, resourceType, resourceId, changes, req) => {
  try {
    await pool.query(
      `INSERT INTO audit_logs (user_id, action, resource_type, resource_id, changes, ip_address, user_agent)
       VALUES ($1, $2, $3, $4, $5, $6, $7)`,
      [userId, action, resourceType, resourceId, JSON.stringify(changes || {}), req.ip, req.get('user-agent')]
    );
  } catch (err) {
    console.error('Error logging audit:', err);
  }
};

const logDataAccess = async (userId, accessedBy, dataType, accessType, req) => {
  try {
    await pool.query(
      `INSERT INTO data_access_logs (user_id, accessed_by, data_type, access_type, ip_address)
       VALUES ($1, $2, $3, $4, $5)`,
      [userId, accessedBy, dataType, accessType, req.ip]
    );
  } catch (err) {
    console.error('Error logging data access:', err);
  }
};

// ============================================
// Server Startup
// ============================================
app.listen(port, async () => {
  await initDatabase();
  console.log(`Data Service listening on port ${port}`);
});

module.exports = app;
