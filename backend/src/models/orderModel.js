const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  customer: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  technician: { type: mongoose.Schema.Types.ObjectId, ref: 'User', default: null },
  brand: { type: String, required: true },
  model: { type: String, required: true },
  issues: [{ type: String }],
  total: { type: Number, default: 0 },
  status: { type: String, enum: ['pending', 'assigned', 'in_progress', 'completed', 'cancelled'], default: 'pending' },
  date: { type: String, required: true },
  eta: { type: String, default: '' },
  rating: { type: String, default: '' },
  jobs: { type: Number, default: 0 },
  distance: { type: String, default: '' },
  experience: { type: String, default: '' },
}, { timestamps: true });

module.exports = mongoose.model('Order', orderSchema);
