const Order = require('../models/orderModel');

const getOrders = async (req, res, next) => {
  try {
    const { role } = req.user;
    let filter = {};
    if (role === 'customer') filter = { customer: req.user.id };
    if (role === 'technician') filter = { technician: req.user.id };

    const orders = await Order.find(filter)
      .populate('customer', 'name email phone location')
      .populate('technician', 'name email phone')
      .sort({ createdAt: -1 });

    res.json({ success: true, count: orders.length, data: orders });
  } catch (error) {
    next(error);
  }
};

const getOrder = async (req, res, next) => {
  try {
    const order = await Order.findById(req.params.id)
      .populate('customer', 'name email phone location')
      .populate('technician', 'name email phone');
    if (!order) return res.status(404).json({ success: false, message: 'Order not found' });
    res.json({ success: true, data: order });
  } catch (error) {
    next(error);
  }
};

const createOrder = async (req, res, next) => {
  try {
    const { brand, model, issues, total, date } = req.body;
    const order = await Order.create({ customer: req.user.id, brand, model, issues, total, date });
    res.status(201).json({ success: true, data: order });
  } catch (error) {
    next(error);
  }
};

const updateOrderStatus = async (req, res, next) => {
  try {
    const { status } = req.body;
    const order = await Order.findById(req.params.id);
    if (!order) return res.status(404).json({ success: false, message: 'Order not found' });
    order.status = status || order.status;
    if (status === 'assigned') order.technician = req.user.id;
    await order.save();
    res.json({ success: true, data: order });
  } catch (error) {
    next(error);
  }
};

const assignTechnician = async (req, res, next) => {
  try {
    const order = await Order.findById(req.params.id);
    if (!order) return res.status(404).json({ success: false, message: 'Order not found' });
    order.technician = req.body.technicianId;
    order.status = 'assigned';
    await order.save();
    res.json({ success: true, data: order });
  } catch (error) {
    next(error);
  }
};

module.exports = { getOrders, getOrder, createOrder, updateOrderStatus, assignTechnician };
