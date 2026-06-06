const mongoose = require('mongoose');

const messageSchema = mongoose.Schema(
  {
    orderId: { type: mongoose.Schema.Types.ObjectId, required: true, ref: 'Order' },
    senderId: { type: mongoose.Schema.Types.ObjectId, required: true, ref: 'User' },
    receiverId: { type: mongoose.Schema.Types.ObjectId, required: true, ref: 'User' },
    message: { type: String, required: true },
  },
  { timestamps: true }
);

// Indexes for rapid query on specific order
messageSchema.index({ orderId: 1, createdAt: -1 });

module.exports = mongoose.model('Message', messageSchema);
