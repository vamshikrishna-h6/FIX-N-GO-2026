const express = require('express');
const { protect } = require('../middleware/authMiddleware');
const {
  getMyNotifications,
  markNotificationRead,
  markAllNotificationsRead,
} = require('../controllers/notificationController');

const router = express.Router();

router.get('/mine', protect, getMyNotifications);
router.patch('/mine/read-all', protect, markAllNotificationsRead);
router.patch('/mine/:id/read', protect, markNotificationRead);

module.exports = router;