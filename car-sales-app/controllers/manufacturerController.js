const db = require('../config/db');

// Получить всех производителей
exports.getAllManufacturers = async (req, res) => {
    try {
        const [rows] = await db.query(`
      SELECT Производители.*, Страны.name AS country_name
      FROM Производители
      LEFT JOIN Страны ON Производители.id_country = Страны.id_country
    `);
        res.json(rows);
    } catch (err) {
        res.status(500).json({ message: 'Ошибка получения производителей', error: err });
    }
};

// Добавить производителя
exports.addManufacturer = async (req, res) => {
    const { name, id_country } = req.body;
    if (!name || !id_country) {
        return res.status(400).json({ message: 'Название и страна обязательны' });
    }

    try {
        const [result] = await db.query(
            'INSERT INTO Производители (name, id_country) VALUES (?, ?)',
            [name, id_country]
        );
        res.status(201).json({ message: 'Производитель добавлен', id: result.insertId });
    } catch (err) {
        res.status(500).json({ message: 'Ошибка добавления производителя', error: err });
    }
};

// Обновить производителя
exports.updateManufacturer = async (req, res) => {
    const { id } = req.params;
    const { name, id_country } = req.body;

    try {
        await db.query(
            'UPDATE Производители SET name = ?, id_country = ? WHERE id_manufacturer = ?',
            [name, id_country, id]
        );
        res.json({ message: 'Производитель обновлён' });
    } catch (err) {
        res.status(500).json({ message: 'Ошибка обновления производителя', error: err });
    }
};

// Удалить производителя
exports.deleteManufacturer = async (req, res) => {
    const { id } = req.params;

    try {
        await db.query('DELETE FROM Производители WHERE id_manufacturer = ?', [id]);
        res.json({ message: 'Производитель удалён' });
    } catch (err) {
        res.status(500).json({ message: 'Ошибка удаления производителя', error: err });
    }
};