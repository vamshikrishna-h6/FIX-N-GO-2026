const User = require('../models/userModel');
const { generateToken } = require('../utils/generateToken');

const register = async (req, res) => {
  const { name, email, phone, password, role } = req.body;
  try {
    const exists = await User.findOne({ email });
    if (exists) return res.status(400).json({ success: false, message: 'User already exists' });

    const user = await User.create({ name, email, phone, password, role: role || 'customer' });
    res.status(201).json({
      success: true,
      token: generateToken(user._id, user.role),
      user: { id: user._id, name: user.name, email: user.email, phone: user.phone, role: user.role, location: user.location },
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const login = async (req, res) => {
  const { email, password, role } = req.body;
  try {
    const user = await User.findOne({ email });
    if (user && (await user.matchPassword(password))) {
      res.json({
        success: true,
        token: generateToken(user._id, user.role),
        user: { id: user._id, name: user.name, email: user.email, phone: user.phone, role: user.role, location: user.location },
      });
    } else {
      res.status(401).json({ success: false, message: 'Invalid credentials' });
    }
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { register, login };
