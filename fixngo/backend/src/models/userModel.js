const mongoose = require('mongoose');

const userSchema = mongoose.Schema(
  {
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    role: { type: String, enum: ['customer', 'technician', 'admin'], default: 'customer' },
    phone: { type: String, default: '' },
    address: { type: String, default: '' },
    city: { type: String, default: 'Hyderabad' },
    pincode: { type: String, default: '' },
    isOnline: { type: Boolean, default: false },
    lastLat: { type: Number, default: null },
    lastLng: { type: Number, default: null },
    location: {
      type: { type: String, default: 'Point' },
      coordinates: { type: [Number], default: [0, 0] },
    },
    technicianMeta: {
      emoji: { type: String, default: '🛠️' },
      rating: { type: Number, default: 4.8 },
      averageRating: { type: Number, default: 0 },
      totalRatings: { type: Number, default: 0 },
      experience: { type: String, default: '' },
      jobsDone: { type: Number, default: 0 },
      specialization: [{ type: String }],
      documents: {
        aadhar: { type: String, default: '' },
        panCard: { type: String, default: '' },
        license: { type: String, default: '' },
      },
      walletBalance: { type: Number, default: 0 },
      pendingEarnings: { type: Number, default: 0 },
      totalEarnings: { type: Number, default: 0 },
    },
    passwordResetOtp: { type: String, default: '' },
    passwordResetOtpExpiry: { type: Date, default: null },
    fcmToken: { type: String, default: '' },
  },
  { timestamps: true }
);

userSchema.index({ location: '2dsphere' });

module.exports = mongoose.model('User', userSchema);

