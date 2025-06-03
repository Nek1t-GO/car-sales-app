

const express = require('express');
const router = express.Router();
const manufacturerController = require('../controllers/manufacturerController');

// Получить всех производителей
router.get('/', manufacturerController.getAllManufacturers);

// Получить одного производителя по ID
router.get('/:id', manufacturerController.getManufacturerById);

// Добавить нового производителя
router.post('/', manufacturerController.createManufacturer);

// Обновить данные производителя
router.put('/:id', manufacturerController.updateManufacturer);

// Удалить производителя
router.delete('/:id', manufacturerController.deleteManufacturer);

module.exports = router;