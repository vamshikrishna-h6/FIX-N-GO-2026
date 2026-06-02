const express = require('express');
const { getNearbyOrders, acceptOrder, updateTechnicianStatus, updateUserProfile } = require('../controllers/technicianController');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

router.route('/orders/nearby').get(protect, getNearbyOrders);
router.route('/orders/:id/accept').post(protect, acceptOrder);
router.route('/status').patch(protect, updateTechnicianStatus);
router.route('/profile').patch(protect, updateUserProfile);

module.exports = router;
