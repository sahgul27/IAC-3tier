const express = require('express');
const { Pool } = require('pg');

const app = express();
const port = 3000;

// PostgreSQL connection pool
const pool = new Pool({
  host: "10.0.4.82",      
  user: "backenduser",
  password: "backendpass123",
  database: "backenddb",
  port: 5432
});

// Root route
app.get('/', (req, res) => {
  res.send('Backend is running!');
});

// /users route
app.get('/users', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM users');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send("Database query failed");
  }
});

app.listen(port, () => {
  console.log(`Backend listening at http://0.0.0.0:${port}`);
});
