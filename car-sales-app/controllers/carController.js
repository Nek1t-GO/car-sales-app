const db = require('../config/db');

// Получить все автомобили
// Получить все автомобили с фильтром по году
exports.getAllCars = async (req, res) => {
    const { year, model } = req.query; // Получаем параметры из запроса

    let query = 'SELECT * FROM Аавтомобили WHERE 1=1';
    let queryParams = [];

    if (year) {
        query += ' AND year = ?';
        queryParams.push(year);
    }

    if (model) {
        query += ' AND id_model = ?';
        queryParams.push(model);
    }

    try {
        const [cars] = await db.query(query, queryParams);
        res.json(cars);
    } catch (err) {
        res.status(500).json({ message: 'Ошибка получения данных', error: err });
    }
};

const { body, validationResult } = require('express-validator');

// Добавить новый автомобиль с валидацией
exports.addCar = [
    body('year').isLength({ min: 4, max: 4 }).withMessage('Year must be a 4-digit number'),
    body('price').isDecimal().withMessage('Price must be a valid decimal number'),
    body('vin').isLength({ min: 4, max: 17 }).withMessage('VIN must be at most 17 characters long'),

    async (req, res) => {
        // Валидация
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(400).json({ errors: errors.array() });
        }

        const { year, id_model, color, vin, price } = req.body;
        try {
            const [result] = await db.query(
                'INSERT INTO Аавтомобили (year, id_model, color, vin, price) VALUES (?, ?, ?, ?, ?)',
                [year, id_model, color, vin, price]
            );
            res.status(201).json({ message: 'Автомобиль добавлен', id: result.insertId });
        } catch (err) {
            res.status(500).json({ message: 'Ошибка добавления автомобиля', error: err });
        }
    }
];

// Обновить автомобиль
exports.updateCar = async (req, res) => {
    const id = req.params.id;
    const { year, id_model, color, vin, price } = req.body;
    try {
        await db.query(
            'UPDATE Аавтомобили SET year = ?, id_model = ?, color = ?, vin = ?, price = ? WHERE id_car = ?',
            [year, id_model, color, vin, price, id]
        );
        res.json({ message: 'Автомобиль обновлён' });
    } catch (err) {
        res.status(500).json({ message: 'Ошибка обновления автомобиля', error: err });
    }
};

// Удалить автомобиль
exports.deleteCar = async (req, res) => {
    const id = req.params.id;
    try {
        await db.query('DELETE FROM Аавтомобили WHERE id_car = ?', [id]);
        res.json({ message: 'Автомобиль удалён' });
    } catch (err) {
        res.status(500).json({ message: 'Ошибка удаления автомобиля', error: err });
    }
};
