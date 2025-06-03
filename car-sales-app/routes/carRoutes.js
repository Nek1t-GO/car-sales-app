// routes/carRoutes.js
const express = require('express');
const router = express.Router();
const carController = require('../controllers/carController');

// Получить все автомобили
router.get('/', carController.getAllCars);

// Добавить новый автомобиль
router.post('/', carController.addCar);

// Изменить автомобиль
router.put('/:id', carController.updateCar);

// Удалить автомобиль
router.delete('/:id', carController.deleteCar);

module.exports = router;