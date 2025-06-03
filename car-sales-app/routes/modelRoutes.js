

const express = require('express');
const router = express.Router();
const modelController = require('../controllers/modelController');

// Получить все модели
router.get('/', modelController.getAllModels);

// Получить модель по ID
router.get('/:id', modelController.getModelById);

// Добавить новую модель
router.post('/', modelController.createModel);

// Обновить модель
router.put('/:id', modelController.updateModel);

// Удалить модель
router.delete('/:id', modelController.deleteModel);

module.exports = router;