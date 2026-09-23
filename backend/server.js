const express = require('express');
const pool = require('./db');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use(cors());

// ============================================
// TENANT MIDDLEWARE
// Har request pe: tenant ID header se nikalo,
// DB session mein set karo
// ============================================
app.use(async (req, res, next) => {
  const tenantId = req.headers['x-tenant-id'];

  if (!tenantId) {
    return res.status(400).json({ error: 'x-tenant-id header is required' });
  }

  try {
    // Har request ke liye ek dedicated DB client lo (connection pool se)
    const client = await pool.connect();
    await client.query(`SET app.current_tenant = '${tenantId}'`);
    req.dbClient = client; // isi client ko aage use karenge
    next();
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to set tenant context' });
  }
});

// ============================================
// TEST ROUTE — Bookings fetch karo
// ============================================
app.get('/bookings', async (req, res) => {
  try {
    const result = await req.dbClient.query('SELECT * FROM bookings');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Query failed' });
  } finally {
    req.dbClient.release(); // connection wapas pool mein bhej do
  }
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});

// ============================================
// TENANTS — RLS-free, admin ke liye
// ============================================
app.get('/tenants', async (req, res) => {
  try {
    const result = await req.dbClient.query('SELECT * FROM tenants');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Query failed' });
  } finally {
    req.dbClient.release();
  }
});

// ============================================
// MEMBERS
// ============================================
app.get('/members', async (req, res) => {
  try {
    const result = await req.dbClient.query('SELECT * FROM members');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Query failed' });
  } finally {
    req.dbClient.release();
  }
});

app.post('/members', async (req, res) => {
  const { tenant_id, branch_id, name, email } = req.body;
  try {
    const result = await req.dbClient.query(
      'INSERT INTO members (tenant_id, branch_id, name, email) VALUES ($1, $2, $3, $4) RETURNING *',
      [tenant_id, branch_id, name, email]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Insert failed' });
  } finally {
    req.dbClient.release();
  }
});

// ============================================
// BOOKING ROOMS
// ============================================
app.get('/rooms', async (req, res) => {
  try {
    const result = await req.dbClient.query('SELECT * FROM booking_rooms');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Query failed' });
  } finally {
    req.dbClient.release();
  }
});

// ============================================
// BOOKINGS — Naya banana
// ============================================
app.post('/bookings', async (req, res) => {
  const { tenant_id, member_id, room_id, start_time, end_time } = req.body;
  try {
    const result = await req.dbClient.query(
      'INSERT INTO bookings (tenant_id, member_id, room_id, start_time, end_time) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [tenant_id, member_id, room_id, start_time, end_time]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Insert failed' });
  } finally {
    req.dbClient.release();
  }
});

// ============================================
// ACCESS LOGS
// ============================================
app.get('/access-logs', async (req, res) => {
  try {
    const result = await req.dbClient.query('SELECT * FROM access_logs ORDER BY logged_at DESC');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Query failed' });
  } finally {
    req.dbClient.release();
  }
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});