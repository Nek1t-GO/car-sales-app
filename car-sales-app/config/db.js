// config/db.js
const mysql = require('mysql2');
const dotenv = require('dotenv');

dotenv.config();
console.log('DB_HOST:', process.env.DB_HOST);
console.log('DB_USER:', process.env.DB_USER);
console.log('DB_PASSWORD:', process.env.DB_PASSWORD);
console.log('DB_NAME:', process.env.DB_NAME);
console.log('DB_PORT:', process.env.DB_PORT);

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT || 3306,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Проверка подключения к базе данных
pool.getConnection((err, connection) => {
    if (err) {
        console.error('Ошибка подключения к базе данных:', err.code, err.message);
    } else {
        console.log('✅ Подключение к базе данных успешно');
        connection.release(); // Освобождаем соединение обратно в пул
    }
});

// Экспорт пула с поддержкой промисов
module.exports = pool.promise();