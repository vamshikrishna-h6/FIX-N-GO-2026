const mongoose = require('mongoose');
const dotenv = require('dotenv');
const Issue = require('../models/issueModel');

dotenv.config({ path: '../.env' });

mongoose.connect(process.env.MONGO_URI).then(async () => {
  console.log('Mongo connected for seeding');
  const existing = await Issue.countDocuments();
  if (existing === 0) {
    await Issue.insertMany([
      { name: 'Screen Broken', emoji: '🖥️', description: 'Cracked, shattered or unresponsive display', price: 999, category: 'repair' },
      { name: 'Battery Issue', emoji: '🔋', description: 'Drains fast, swollen or not charging', price: 599, category: 'repair' },
      { name: 'Charging Port', emoji: '⚡', description: 'Loose connection, not charging', price: 499, category: 'repair' },
      { name: 'Speaker / Mic', emoji: '🔊', description: 'No sound, distortion or mic failure', price: 399, category: 'repair' },
      { name: 'Back Glass', emoji: '🪟', description: 'Cracked rear panel replacement', price: 799, category: 'repair' },
      { name: 'Camera Issue', emoji: '📷', description: 'Blurry, black screen or won't open', price: 699, category: 'repair' },
      { name: 'Screen Guard', emoji: '🛡️', description: 'Bubble-free tempered glass at door', price: 199, category: 'accessory' },
      { name: 'Water Damage', emoji: '💧', description: 'Wet phone, corrosion deep-clean', price: 1199, category: 'repair' },
      { name: 'Software / Hang', emoji: '💻', description: 'Phone freezes, apps crash, slow', price: 299, category: 'software' },
    ]);
    console.log('Seeded issues');
  }
  mongoose.disconnect();
});
