const express = require('express');
const { protect } = require('../middleware/authMiddleware');
const { authorize } = require('../middleware/roleMiddleware');
const {
  getAllOrders,
  updateOrderStatus,
  getStats,
  getAllUsers,
  assignTechnician,
  getAllTechnicians,
  approveTechnician,
  suspendTechnician,
} = require('../controllers/adminController');

const router = express.Router();

router.use(protect, authorize('admin'));

router.get('/stats', getStats);
router.get('/orders', getAllOrders);
router.patch('/orders/:id', updateOrderStatus);
router.post('/orders/assign', assignTechnician);
router.get('/users', getAllUsers);

// Technician management
router.get('/technicians', getAllTechnicians);
router.patch('/technicians/:id/approve', approveTechnician);
router.patch('/technicians/:id/suspend', suspendTechnician);

module.exports = router;
