// controllers/clientController.js
const db = require('../config/db');

// Получить всех клиентов
exports.getAllClients = async (req, res) => {
    try {
        const [results] = await db.query('SELECT * FROM Клиенты');
        res.json(results);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

// Получить клиента по ID
exports.getClientById = async (req, res) => {
    try {
        const id = req.params.id;
        const [result] = await db.query('SELECT * FROM Клиенты WHERE id_client = ?', [id]);
        if (result.length === 0) {
            return res.status(404).json({ message: 'Клиент не найден' });
        }
        res.json(result[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

// Создать клиента
exports.createClient = async (req, res) => {
    try {
        const { full_name, phone, email, address } = req.body;
        console.log('📤 Создание клиента с данными:', req.body); // <--- ДОБАВЛЕНО

        const [result] = await db.query(
            'INSERT INTO Клиенты (full_name, phone, email, address) VALUES (?, ?, ?, ?)',
            [full_name, phone, email, address]
        );
        res.status(201).json({ message: 'Клиент создан', id: result.insertId });
    } catch (err) {
        console.error('❌ Ошибка при создании клиента:', err); // <--- ДОБАВЛЕНО
        res.status(500).json({ error: err.message });
    }
};

// Обновить клиента
exports.updateClient = async (req, res) => {
    try {
        const id = req.params.id;
        console.log('Данные для обновления клиента:', req.body);
        const { full_name, phone, email, address } = req.body;
        await db.query(
            'UPDATE Клиенты SET full_name = ?, phone = ?, email = ?, address = ? WHERE id_client = ?',
            [full_name, phone, email, address, id]
        );
        res.json({ message: 'Клиент обновлён' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

// Удалить клиента
exports.deleteClient = async (req, res) => {
    try {
        const id = req.params.id;
        console.log('Удаляем клиента с id:', id);
        await db.query('DELETE FROM Клиенты WHERE id_client = ?', [id]);
        res.json({ message: 'Клиент удалён' });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

exports.getAllCars = async (req, res) => {
    try {
        console.log('Запрос: получить все автомобили');
        const [cars] = await db.query('SELECT * FROM Аавтомобили');
        res.json(cars);
    } catch (err) {
        console.error('Ошибка при получении автомобилей:', err);
        res.status(500).json({ message: 'Ошибка сервера', error: err });
    }
};