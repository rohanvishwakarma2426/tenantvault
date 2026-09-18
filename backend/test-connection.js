const { Client } = require('pg');

const client = new Client({
  host: 'localhost',
  port: 5434,
  user: 'app_user',
  password: 'app_pass123',
  database: 'tenantvault',
});

client.connect()
  .then(() => {
    console.log('✅ Connected successfully!');
    return client.end();
  })
  .catch((err) => {
    console.error('❌ Connection failed:', err.message);
  });