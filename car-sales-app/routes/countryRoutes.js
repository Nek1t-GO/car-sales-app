

const express = require('express');
const router = express.Router();
const countryController = require('../controllers/countryController');

// Получить все страны
router.get('/', countryController.getAllCountries);

// Добавить страну
router.post('/', countryController.addCountry);

// Обновить страну
router.put('/:id', countryController.updateCountry);

// Удалить страну
router.delete('/:id', countryController.deleteCountry);

module.exports = router;