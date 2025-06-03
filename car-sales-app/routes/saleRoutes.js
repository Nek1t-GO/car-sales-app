const express = require('express');
const router = express.Router();
const salesController = require('../controllers/saleController');

router.get('/', salesController.getAllSales);
router.get('/:id', salesController.getSaleById);
router.post('/', salesController.createSale);
router.put('/:id', salesController.updateSale);
router.delete('/:id', salesController.deleteSale);

console.log('saleRoutes.js загружен');

module.exports = router;