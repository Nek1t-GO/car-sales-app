const db = require('../config/db');

// Получить все продажи
exports.getAllSales = async (req, res) => {
    try {
        const [sales] = await db.query('SELECT * FROM Продажи');
        res.json(sales);
    } catch (err) {
        res.status(500).json({ message: 'Ошибка получения продаж', error: err });
    }
};

// Получить продажу по ID
exports.getSaleById = async (req, res) => {
    const id = req.params.id;
    try {
        const [sale] = await db.query('SELECT * FROM Продажи WHERE id_sale = ?', [id]);
        if (sale.length === 0) {
            return res.status(404).json({ message: 'Продажа не найдена' });
        }
        res.json(sale[0]);
    } catch (err) {
        res.status(500).json({ message: 'Ошибка получения продажи', error: err });
    }
};

// Создать новую продажу
exports.createSale = async (req, res) => {
    const { id_client, id_car, id_employee, sale_date, final_price } = req.body;
    try {
        const [result] = await db.query(
            'INSERT INTO Продажи (id_client, id_car, id_employee, sale_date, final_price) VALUES (?, ?, ?, ?, ?)',
            [id_client, id_car, id_employee, sale_date, final_price]
        );
        res.status(201).json({ message: 'Продажа создана', id: result.insertId });
    } catch (err) {
        res.status(500).json({ message: 'Ошибка создания продажи', error: err });
    }
};

// Обновить продажу
exports.updateSale = async (req, res) => {
    const id = req.params.id;
    const { id_client, id_car, id_employee, sale_date, final_price } = req.body;
    try {
        await db.query(
            'UPDATE Продажи SET id_client = ?, id_car = ?, id_employee = ?, sale_date = ?, final_price = ? WHERE id_sale = ?',
            [id_client, id_car, id_employee, sale_date, final_price, id]
        );
        res.json({ message: 'Продажа обновлена' });
    } catch (err) {
        res.status(500).json({ message: 'Ошибка обновления продажи', error: err });
    }
};

// Удалить продажу
exports.deleteSale = async (req, res) => {
    const id = req.params.id;
    try {
        await db.query('DELETE FROM Продажи WHERE id_sale = ?', [id]);
        res.json({ message: 'Продажа удалена' });
    } catch (err) {
        res.status(500).json({ message: 'Ошибка удаления продажи', error: err });
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