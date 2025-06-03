const db = require('../config/db');

// Получить все модели
exports.getAllModels = async (req, res) => {
    try {
        const [rows] = await db.query(`
      SELECT Модели.*, Производители.name AS manufacturer_name
      FROM Модели
      JOIN Производители ON Модели.id_manufacturer = Производители.id_manufacturer
    `);
        res.json(rows);
    } catch (err) {
        console.error('Ошибка при получении моделей:', err);
        res.status(500).json({ message: 'Ошибка при получении моделей', error: err });
    }
};

// Получить модель по ID
exports.getModelById = async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM Модели WHERE id_model = ?', [req.params.id]);
        if (rows.length === 0) {
            return res.status(404).json({ message: 'Модель не найдена' });
        }
        res.json(rows[0]);
    } catch (err) {
        res.status(500).json({ message: 'Ошибка при получении модели', error: err });
    }
};

// Добавить модель
exports.createModel = async (req, res) => {
    const { model, body_types, engine_capacity, id_manufacturer } = req.body;
    try {
        const [result] = await db.query(
            'INSERT INTO Модели (model, body_types, engine_capacity, id_manufacturer) VALUES (?, ?, ?, ?)',
            [model, body_types, engine_capacity, id_manufacturer]
        );
        res.status(201).json({ message: 'Модель добавлена', id: result.insertId });
    } catch (err) {
        res.status(500).json({ message: 'Ошибка при добавлении модели', error: err });
    }
};

// Обновить модель
exports.updateModel = async (req, res) => {
    const { model, body_types, engine_capacity, id_manufacturer } = req.body;
    const id = req.params.id;
    try {
        await db.query(
            'UPDATE Модели SET model = ?, body_types = ?, engine_capacity = ?, id_manufacturer = ? WHERE id_model = ?',
            [model, body_types, engine_capacity, id_manufacturer, id]
        );
        res.json({ message: 'Модель обновлена' });
    } catch (err) {
        res.status(500).json({ message: 'Ошибка при обновлении модели', error: err });
    }
};

// Удалить модель
exports.deleteModel = async (req, res) => {
    try {
        await db.query('DELETE FROM Модели WHERE id_model = ?', [req.params.id]);
        res.json({ message: 'Модель удалена' });
    } catch (err) {
        res.status(500).json({ message: 'Ошибка при удалении модели', error: err });
    }
};