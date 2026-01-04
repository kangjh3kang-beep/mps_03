const express = require('express');
const axios = require('axios');
const jwt = require('jsonwebtoken');
const Stripe = require('stripe');
const { Pool } = require('pg');

const app = express();
const port = process.env.PORT || 3004;

// ============================================
// Configuration
// ============================================
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY || 'sk_test_demo');
const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'password',
  host: process.env.DB_HOST || 'db',
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || 'mps_payment',
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
    // Create tables
    await client.query(`
      CREATE TABLE IF NOT EXISTS payment_methods (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) NOT NULL,
        stripe_payment_method_id VARCHAR(255) UNIQUE,
        type VARCHAR(50),
        brand VARCHAR(50),
        last4 VARCHAR(4),
        exp_month INTEGER,
        exp_year INTEGER,
        is_default BOOLEAN DEFAULT false,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(user_id, stripe_payment_method_id)
      );

      CREATE TABLE IF NOT EXISTS transactions (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) NOT NULL,
        transaction_id VARCHAR(255) UNIQUE,
        type VARCHAR(50),
        amount DECIMAL(10, 2),
        currency VARCHAR(3) DEFAULT 'KRW',
        status VARCHAR(50),
        payment_method_id INTEGER,
        description TEXT,
        metadata JSONB,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS invoices (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) NOT NULL,
        transaction_id VARCHAR(255),
        invoice_number VARCHAR(255) UNIQUE,
        amount DECIMAL(10, 2),
        currency VARCHAR(3) DEFAULT 'KRW',
        status VARCHAR(50),
        due_date TIMESTAMP,
        issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        paid_at TIMESTAMP,
        FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
      );

      CREATE TABLE IF NOT EXISTS subscriptions (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) NOT NULL,
        stripe_subscription_id VARCHAR(255) UNIQUE,
        plan_id VARCHAR(100),
        plan_name VARCHAR(255),
        amount_per_month DECIMAL(10, 2),
        currency VARCHAR(3) DEFAULT 'KRW',
        billing_cycle VARCHAR(50),
        status VARCHAR(50),
        start_date TIMESTAMP,
        renewal_date TIMESTAMP,
        cancel_date TIMESTAMP,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS refunds (
        id SERIAL PRIMARY KEY,
        transaction_id VARCHAR(255),
        stripe_refund_id VARCHAR(255) UNIQUE,
        amount DECIMAL(10, 2),
        reason VARCHAR(255),
        status VARCHAR(50),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id)
      );

      CREATE TABLE IF NOT EXISTS payment_plans (
        id SERIAL PRIMARY KEY,
        plan_id VARCHAR(100) UNIQUE,
        plan_name VARCHAR(255),
        description TEXT,
        amount_per_month DECIMAL(10, 2),
        amount_per_year DECIMAL(10, 2),
        currency VARCHAR(3) DEFAULT 'KRW',
        features JSONB,
        is_active BOOLEAN DEFAULT true,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON transactions(user_id);
      CREATE INDEX IF NOT EXISTS idx_subscriptions_user_id ON subscriptions(user_id);
      CREATE INDEX IF NOT EXISTS idx_invoices_user_id ON invoices(user_id);
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
    service: 'payment-service',
    timestamp: new Date().toISOString(),
  });
});

// ============================================
// Payment Methods
// ============================================

// List payment methods
app.get('/api/v1/payment-methods', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM payment_methods WHERE user_id = $1 ORDER BY is_default DESC, created_at DESC',
      [req.user.id]
    );
    res.json({
      success: true,
      data: result.rows,
      count: result.rows.length,
    });
  } catch (err) {
    console.error('Error fetching payment methods:', err);
    res.status(500).json({ error: '결제 방법 조회 실패' });
  }
});

// Add payment method
app.post('/api/v1/payment-methods', authenticateToken, async (req, res) => {
  try {
    const { payment_method_token, make_default } = req.body;

    // Stripe에 결제 방법 추가
    const paymentMethod = await stripe.paymentMethods.create({
      type: 'card',
      card: { token: payment_method_token },
    });

    // DB에 저장
    const result = await pool.query(
      `INSERT INTO payment_methods 
       (user_id, stripe_payment_method_id, type, brand, last4, exp_month, exp_year, is_default)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
       RETURNING *`,
      [
        req.user.id,
        paymentMethod.id,
        paymentMethod.type,
        paymentMethod.card.brand,
        paymentMethod.card.last4,
        paymentMethod.card.exp_month,
        paymentMethod.card.exp_year,
        make_default || false,
      ]
    );

    res.status(201).json({
      success: true,
      message: '결제 방법이 추가되었습니다',
      data: result.rows[0],
    });
  } catch (err) {
    console.error('Error adding payment method:', err);
    res.status(500).json({ error: '결제 방법 추가 실패' });
  }
});

// Delete payment method
app.delete('/api/v1/payment-methods/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      'DELETE FROM payment_methods WHERE id = $1 AND user_id = $2 RETURNING *',
      [id, req.user.id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: '결제 방법을 찾을 수 없습니다' });
    }

    res.json({
      success: true,
      message: '결제 방법이 삭제되었습니다',
    });
  } catch (err) {
    console.error('Error deleting payment method:', err);
    res.status(500).json({ error: '결제 방법 삭제 실패' });
  }
});

// ============================================
// Transactions
// ============================================

// Process payment
app.post('/api/v1/payments', authenticateToken, async (req, res) => {
  try {
    const { amount, currency, payment_method_id, description, metadata } = req.body;

    // Get payment method
    const pmResult = await pool.query(
      'SELECT stripe_payment_method_id FROM payment_methods WHERE id = $1 AND user_id = $2',
      [payment_method_id, req.user.id]
    );

    if (pmResult.rowCount === 0) {
      return res.status(404).json({ error: '결제 방법을 찾을 수 없습니다' });
    }

    const stripePaymentMethodId = pmResult.rows[0].stripe_payment_method_id;

    // Create payment intent
    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(amount * 100), // Convert to cents
      currency: currency.toLowerCase(),
      payment_method: stripePaymentMethodId,
      confirm: true,
      description: description || 'MPS Payment',
      metadata: metadata || {},
    });

    // Record transaction
    const txResult = await pool.query(
      `INSERT INTO transactions
       (user_id, transaction_id, type, amount, currency, status, payment_method_id, description, metadata)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
       RETURNING *`,
      [
        req.user.id,
        paymentIntent.id,
        'payment',
        amount,
        currency,
        paymentIntent.status,
        payment_method_id,
        description,
        JSON.stringify(metadata || {}),
      ]
    );

    res.status(200).json({
      success: true,
      message: '결제가 완료되었습니다',
      data: {
        transactionId: txResult.rows[0].transaction_id,
        amount: txResult.rows[0].amount,
        currency: txResult.rows[0].currency,
        status: txResult.rows[0].status,
        timestamp: txResult.rows[0].created_at,
      },
    });
  } catch (err) {
    console.error('Error processing payment:', err);
    res.status(500).json({ error: '결제 처리 실패' });
  }
});

// Get transaction
app.get('/api/v1/transactions/:id', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM transactions WHERE transaction_id = $1 AND user_id = $2',
      [req.params.id, req.user.id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: '거래를 찾을 수 없습니다' });
    }

    res.json({
      success: true,
      data: result.rows[0],
    });
  } catch (err) {
    console.error('Error fetching transaction:', err);
    res.status(500).json({ error: '거래 조회 실패' });
  }
});

// List transactions
app.get('/api/v1/transactions', authenticateToken, async (req, res) => {
  try {
    const { status, type, limit = 50, offset = 0 } = req.query;
    let query = 'SELECT * FROM transactions WHERE user_id = $1';
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
    console.error('Error fetching transactions:', err);
    res.status(500).json({ error: '거래 조회 실패' });
  }
});

// ============================================
// Subscriptions
// ============================================

// Create subscription
app.post('/api/v1/subscriptions', authenticateToken, async (req, res) => {
  try {
    const { plan_id, payment_method_id } = req.body;

    // Get plan
    const planResult = await pool.query(
      'SELECT * FROM payment_plans WHERE plan_id = $1 AND is_active = true',
      [plan_id]
    );

    if (planResult.rowCount === 0) {
      return res.status(404).json({ error: '플랜을 찾을 수 없습니다' });
    }

    const plan = planResult.rows[0];

    // Get payment method
    const pmResult = await pool.query(
      'SELECT stripe_payment_method_id FROM payment_methods WHERE id = $1',
      [payment_method_id]
    );

    if (pmResult.rowCount === 0) {
      return res.status(404).json({ error: '결제 방법을 찾을 수 없습니다' });
    }

    // Create subscription with Stripe
    const subscription = await stripe.subscriptions.create({
      customer: req.user.stripe_customer_id || req.user.id,
      items: [{ price_data: { currency: 'krw', product_data: { name: plan.plan_name }, unit_amount: Math.round(plan.amount_per_month * 100) }, recurring: { interval: 'month' } }],
      default_payment_method: pmResult.rows[0].stripe_payment_method_id,
      automatic_tax: { enabled: true },
    });

    // Record subscription
    const subResult = await pool.query(
      `INSERT INTO subscriptions
       (user_id, stripe_subscription_id, plan_id, plan_name, amount_per_month, currency, billing_cycle, status, start_date, renewal_date)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, NOW(), NOW() + INTERVAL '1 month')
       RETURNING *`,
      [
        req.user.id,
        subscription.id,
        plan_id,
        plan.plan_name,
        plan.amount_per_month,
        'KRW',
        'monthly',
        subscription.status,
      ]
    );

    res.status(201).json({
      success: true,
      message: '구독이 생성되었습니다',
      data: subResult.rows[0],
    });
  } catch (err) {
    console.error('Error creating subscription:', err);
    res.status(500).json({ error: '구독 생성 실패' });
  }
});

// Get subscription
app.get('/api/v1/subscriptions/:id', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM subscriptions WHERE stripe_subscription_id = $1 AND user_id = $2',
      [req.params.id, req.user.id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: '구독을 찾을 수 없습니다' });
    }

    res.json({
      success: true,
      data: result.rows[0],
    });
  } catch (err) {
    console.error('Error fetching subscription:', err);
    res.status(500).json({ error: '구독 조회 실패' });
  }
});

// Cancel subscription
app.post('/api/v1/subscriptions/:id/cancel', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;

    const subResult = await pool.query(
      'SELECT stripe_subscription_id FROM subscriptions WHERE stripe_subscription_id = $1 AND user_id = $2',
      [id, req.user.id]
    );

    if (subResult.rowCount === 0) {
      return res.status(404).json({ error: '구독을 찾을 수 없습니다' });
    }

    // Cancel with Stripe
    await stripe.subscriptions.del(id);

    // Update DB
    const result = await pool.query(
      'UPDATE subscriptions SET status = $1, cancel_date = NOW() WHERE stripe_subscription_id = $2 RETURNING *',
      ['canceled', id]
    );

    res.json({
      success: true,
      message: '구독이 취소되었습니다',
      data: result.rows[0],
    });
  } catch (err) {
    console.error('Error canceling subscription:', err);
    res.status(500).json({ error: '구독 취소 실패' });
  }
});

// ============================================
// Invoices
// ============================================

// Get invoice
app.get('/api/v1/invoices/:id', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM invoices WHERE id = $1 AND user_id = $2',
      [req.params.id, req.user.id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ error: '인보이스를 찾을 수 없습니다' });
    }

    res.json({
      success: true,
      data: result.rows[0],
    });
  } catch (err) {
    console.error('Error fetching invoice:', err);
    res.status(500).json({ error: '인보이스 조회 실패' });
  }
});

// List invoices
app.get('/api/v1/invoices', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM invoices WHERE user_id = $1 ORDER BY issued_at DESC LIMIT 50',
      [req.user.id]
    );

    res.json({
      success: true,
      data: result.rows,
      count: result.rows.length,
    });
  } catch (err) {
    console.error('Error fetching invoices:', err);
    res.status(500).json({ error: '인보이스 조회 실패' });
  }
});

// ============================================
// Refunds
// ============================================

// Create refund
app.post('/api/v1/refunds', authenticateToken, async (req, res) => {
  try {
    const { transaction_id, amount, reason } = req.body;

    // Get transaction
    const txResult = await pool.query(
      'SELECT * FROM transactions WHERE transaction_id = $1 AND user_id = $2',
      [transaction_id, req.user.id]
    );

    if (txResult.rowCount === 0) {
      return res.status(404).json({ error: '거래를 찾을 수 없습니다' });
    }

    const transaction = txResult.rows[0];

    // Create refund with Stripe
    const refund = await stripe.refunds.create({
      payment_intent: transaction_id,
      amount: amount ? Math.round(amount * 100) : undefined,
      reason: reason || 'requested_by_customer',
    });

    // Record refund
    const refResult = await pool.query(
      `INSERT INTO refunds
       (transaction_id, stripe_refund_id, amount, reason, status)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING *`,
      [transaction_id, refund.id, amount || transaction.amount, reason, refund.status]
    );

    res.status(201).json({
      success: true,
      message: '환불이 요청되었습니다',
      data: refResult.rows[0],
    });
  } catch (err) {
    console.error('Error creating refund:', err);
    res.status(500).json({ error: '환불 생성 실패' });
  }
});

// ============================================
// Server Startup
// ============================================
app.listen(port, async () => {
  await initDatabase();
  console.log(`Payment Service listening on port ${port}`);
});

module.exports = app;
