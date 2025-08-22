const { Pool } = require('pg');

const pool = new Pool({
  user: 'backenduser',
  host: 'PRIVATE_DB_IP',
  database: 'backenddb',
  password: 'backendpass123',
  port: 5432,
});

pool.query('SELECT NOW()', (err, res) => {
  if (err) console.error(err);
  else console.log('DB Connected:', res.rows[0]);
});
