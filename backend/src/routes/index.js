const express = require('express');
const authRoutes = require('./authRoutes');
const orderRoutes = require('./orderRoutes');
const technicianRoutes = require('./technicianRoutes');
const serviceRoutes = require('./serviceRoutes');

const router = express.Router();

router.use('/api/auth', authRoutes);
router.use('/api/orders', orderRoutes);
router.use('/api/technician', technicianRoutes);
router.use('/api/services', serviceRoutes);

router.get('/api/health', (req, res) => {
  res.status(200).json({ success: true, message: 'Fix-N-Go backend is running' });
});

module.exports = router;
