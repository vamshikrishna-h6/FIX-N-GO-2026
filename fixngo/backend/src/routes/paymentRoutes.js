const express = require('express');
const {
  createPaymentIntent,
  confirmPayment,
  getPaymentHistory,
  getTechnicianEarnings,
  getMonthlyEarnings,
  requestWithdrawal,
  getWithdrawalHistory,
  handleStripeWebhook,
  getAllWithdrawals,
  approveWithdrawal,
  rejectWithdrawal,
} = require('../controllers/paymentController');
const { protect } = require('../middleware/authMiddleware');
const { authorize } = require('../middleware/roleMiddleware');

const router = express.Router();

// Stripe Webhook — must use raw body, placed BEFORE json parser
router.post('/webhook', express.raw({ type: 'application/json' }), handleStripeWebhook);

// Payment endpoints
router.post('/create-intent', protect, createPaymentIntent);
router.post('/confirm', protect, confirmPayment);
router.get('/history', protect, getPaymentHistory);

// Technician earnings endpoints
router.get('/earnings', protect, authorize('technician'), getTechnicianEarnings);
router.get('/earnings/monthly', protect, authorize('technician'), getMonthlyEarnings);
router.post('/withdraw', protect, authorize('technician'), requestWithdrawal);
router.get('/withdraw/history', protect, authorize('technician'), getWithdrawalHistory);

// Admin withdrawal management
router.get('/admin/withdrawals', protect, authorize('admin'), getAllWithdrawals);
router.patch('/admin/withdrawals/:id/approve', protect, authorize('admin'), approveWithdrawal);
router.patch('/admin/withdrawals/:id/reject', protect, authorize('admin'), rejectWithdrawal);

module.exports = router;
