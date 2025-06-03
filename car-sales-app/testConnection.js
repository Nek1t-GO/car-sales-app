require('dotenv').config();

console.log('DB_HOST:', process.env.DB_HOST);
console.log('DB_USER:', process.env.DB_USER);
console.log('DB_PASSWORD:', process.env.DB_PASSWORD);
console.log('DB_NAME:', process.env.DB_NAME);

const db = require('./config/db');

db.getConnection()
    .then(conn => {
        console.log('✅ Успешное подключение к MySQL');
        conn.release();
    })
    .catch(err => {
        console.error('❌ Ошибка подключения:', err);
    });