const express = require('express');
const { protect } = require('../middleware/authMiddleware');
const { createSupportTicket, getMySupportTickets } = require('../controllers/supportController');

const router = express.Router();

router.get('/mine', protect, getMySupportTickets);
router.post('/', protect, createSupportTicket);

module.exports = router;