const express = require('express');
const { getOrders, getOrder, createOrder, updateOrderStatus } = require('../controllers/orderController');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

router.route('/').get(protect, getOrders).post(protect, createOrder);
router.route('/:id').get(protect, getOrder);
router.route('/:id/status').patch(protect, updateOrderStatus);

module.exports = router;
