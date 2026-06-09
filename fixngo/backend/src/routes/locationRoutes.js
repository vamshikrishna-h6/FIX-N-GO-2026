const express = require('express');
const router = express.Router();
const { protect: authMiddleware } = require('../middleware/authMiddleware');
const {
  getNearbyOrders,
  getLocationSuggestions,
  getPlaceDetails,
  getRoute,
  updateTechnicianLocation,
} = require('../controllers/locationController');

// Location routes — all require authentication
router.post('/nearby-orders', authMiddleware, getNearbyOrders);
router.post('/suggestions', authMiddleware, getLocationSuggestions);
router.post('/place-details', authMiddleware, getPlaceDetails);
router.post('/route', authMiddleware, getRoute);
router.post('/update-location', authMiddleware, updateTechnicianLocation);

module.exports = router;
