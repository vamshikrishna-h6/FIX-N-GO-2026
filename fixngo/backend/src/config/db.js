const mongoose = require('mongoose');

const connectDB = async () => {
  const uri = process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/fixngo';

  try {
    const conn = await mongoose.connect(uri);
    console.log(`MongoDB Connected: ${conn.connection.host}`);
  } catch (error) {
    console.error('DB Connection Error:', error.message);
    process.exit(1);
  }

  // Runtime connection event listeners
  mongoose.connection.on('error', (err) => {
    console.error('MongoDB runtime connection error:', err.message);
  });

  mongoose.connection.on('disconnected', () => {
    console.warn('MongoDB disconnected. Attempting to reconnect…');
  });

  mongoose.connection.on('reconnected', () => {
    console.log('MongoDB reconnected');
  });
};

module.exports = connectDB;
