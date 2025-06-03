const db = require('../config/db');

// Получить всех сотрудников
exports.getAllEmployees = async (req, res) => {
    try {
        const [rows] = await db.query('SELECT * FROM Сотрудники');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: 'Ошибка при получении сотрудников', details: err });
    }
};

// Получить сотрудника по ID
exports.getEmployeeById = async (req, res) => {
    const id = req.params.id;
    try {
        const [rows] = await db.query('SELECT * FROM Сотрудники WHERE id_employee = ?', [id]);
        if (rows.length === 0) {
            res.status(404).json({ message: 'Сотрудник не найден' });
        } else {
            res.json(rows[0]);
        }
    } catch (err) {
        res.status(500).json({ error: 'Ошибка при получении сотрудника', details: err });
    }
};

// Добавить нового сотрудника
exports.createEmployee = async (req, res) => {
    const { full_name, position } = req.body;
    try {
        const [result] = await db.query(
            'INSERT INTO Сотрудники (full_name, position) VALUES (?, ?)',
            [full_name, position]
        );
        res.status(201).json({ message: 'Сотрудник добавлен', id: result.insertId });
    } catch (err) {
        res.status(500).json({ error: 'Ошибка при добавлении сотрудника', details: err });
    }
};

// Обновить данные сотрудника
exports.updateEmployee = async (req, res) => {
    const id = req.params.id;
    const { full_name, position } = req.body;
    try {
        const [result] = await db.query(
            'UPDATE Сотрудники SET full_name = ?, position = ? WHERE id_employee = ?',
            [full_name, position, id]
        );
        res.json({ message: 'Данные сотрудника обновлены' });
    } catch (err) {
        res.status(500).json({ error: 'Ошибка при обновлении сотрудника', details: err });
    }
};

// Удалить сотрудника
exports.deleteEmployee = async (req, res) => {
    const id = req.params.id;
    try {
        await db.query('DELETE FROM Сотрудники WHERE id_employee = ?', [id]);
        res.json({ message: 'Сотрудник удалён' });
    } catch (err) {
        res.status(500).json({ error: 'Ошибка при удалении сотрудника', details: err });
    }
};
