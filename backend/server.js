const express = require('express');
const pool = require('./db');
require('dotenv').config();

const app = express();
app.use(express.json());

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