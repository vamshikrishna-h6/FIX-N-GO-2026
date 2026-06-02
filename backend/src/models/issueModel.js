const mongoose = require('mongoose');

const issueSchema = new mongoose.Schema({
  name: { type: String, required: true },
  emoji: { type: String, default: '' },
  description: { type: String, default: '' },
  price: { type: Number, required: true },
  category: { type: String, default: 'repair' },
}, { timestamps: true });

module.exports = mongoose.model('Issue', issueSchema);
