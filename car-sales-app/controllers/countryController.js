

const db = require('../config/db');

// Получить все страны
exports.getAllCountries = async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM Страны');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ message: 'Ошибка получения стран', error: err });
    }
};

// Добавить страну
exports.addCountry = async (req, res) => {
    const { name } = req.body;
    if (!name) return res.status(400).json({ message: 'Название страны обязательно' });

    try {
        const [result] = await db.query(
            'INSERT INTO Страны (name) VALUES (?)',
            [name]
        );
        res.status(201).json({ message: 'Страна добавлена', id: result.insertId });
    } catch (err) {
        res.status(500).json({ message: 'Ошибка добавления страны', error: err });
    }
};

// Обновить страну
exports.updateCountry = async (req, res) => {
    const { id } = req.params;
    const { name } = req.body;

    try {
        await db.query(
            'UPDATE Страны SET name = ? WHERE id_country = ?',
            [name, id]
        );
        res.json({ message: 'Страна обновлена' });
    } catch (err) {
        res.status(500).json({ message: 'Ошибка обновления страны', error: err });
    }
};

// Удалить страну
exports.deleteCountry = async (req, res) => {
    const { id } = req.params;

    try {
        await db.query('DELETE FROM Страны WHERE id_country = ?', [id]);
        res.json({ message: 'Страна удалена' });
    } catch (err) {
        res.status(500).json({ message: 'Ошибка удаления страны', error: err });
    }
};