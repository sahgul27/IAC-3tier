const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: 5432,
});

pool.query('SELECT NOW()', (err, res) => {
  if (err) console.error(err);
  else console.log('DB Connected:', res.rows[0]);
});