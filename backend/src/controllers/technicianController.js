const Order = require('../models/orderModel');
const User = require('../models/userModel');

const getNearbyOrders = async (req, res, next) => {
  try {
    const orders = await Order.find({ status: 'pending' })
      .populate('customer', 'name email phone location')
      .sort({ createdAt: -1 });
    res.json({ success: true, count: orders.length, data: orders });
  } catch (error) {
    next(error);
  }
};

const acceptOrder = async (req, res, next) => {
  try {
    const order = await Order.findById(req.params.id);
    if (!order) return res.status(404).json({ success: false, message: 'Order not found' });
    if (order.status !== 'pending') {
      return res.status(400).json({ success: false, message: 'Order already accepted' });
    }
    order.technician = req.user.id;
    order.status = 'assigned';
    await order.save();

    res.json({ success: true, message: 'Order accepted', data: order });
  } catch (error) {
    next(error);
  }
};

const updateTechnicianStatus = async (req, res, next) => {
  try {
    const { status } = req.body;
    await User.findByIdAndUpdate(req.user.id, { status });
    res.json({ success: true, message: 'Status updated' });
  } catch (error) {
    next(error);
  }
};

const updateUserProfile = async (req, res, next) => {
  try {
    const { name, phone, location } = req.body;
    const user = await User.findByIdAndUpdate(req.user.id, { name, phone, location }, { new: true });
    res.json({ success: true, data: user });
  } catch (error) {
    next(error);
  }
};

module.exports = { getNearbyOrders, acceptOrder, updateTechnicianStatus, updateUserProfile };
