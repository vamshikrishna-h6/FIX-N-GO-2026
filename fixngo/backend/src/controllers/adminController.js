const Order = require('../models/orderModel');
const User = require('../models/userModel');
const Service = require('../models/serviceModel');
const Withdrawal = require('../models/withdrawalModel');
const { assignById } = require('../utils/technicianAssignment');
const { notFound, badRequest } = require('../utils/responseHelpers');

const getAllOrders = async (req, res, next) => {
  try {
    const orders = await Order.find()
      .populate('user', 'name email')
      .populate('technicianUser', 'name email phone')
      .sort({ createdAt: -1 });
    res.json(orders);
  } catch (error) {
    next(error);
  }
};

const updateOrderStatus = async (req, res, next) => {
  try {
    const { status } = req.body;
    const allowed = ['pending', 'assigned', 'in_progress', 'completed', 'cancelled'];
    if (!status || !allowed.includes(status)) {
      return badRequest(res, `Status must be one of: ${allowed.join(', ')}`);
    }

    const order = await Order.findById(req.params.id);
    if (!order) return notFound(res, 'Order');

    order.status = status;
    await order.save();
    res.json(order);
  } catch (error) {
    next(error);
  }
};

const getStats = async (req, res, next) => {
  try {
    const [orders, users, services, technicians] = await Promise.all([
      Order.countDocuments(),
      User.countDocuments({ role: 'customer' }),
      Service.countDocuments(),
      User.countDocuments({ role: 'technician' }),
    ]);
    const admins = await User.countDocuments({ role: 'admin' });
    const pending = await Order.countDocuments({ status: 'pending' });
    const completed = await Order.countDocuments({ status: 'completed' });

    res.json({ orders, users, services, technicians, admins, pending, completed });
  } catch (error) {
    next(error);
  }
};

const assignTechnician = async (req, res, next) => {
  try {
    const { orderId, technicianId } = req.body;
    const order = await Order.findById(orderId);
    if (!order) return notFound(res, 'Order');

    const tech = await assignById(order, technicianId);
    if (!tech) return notFound(res, 'Technician');

    res.json({ success: true, order });
  } catch (error) {
    next(error);
  }
};

const getAllUsers = async (req, res, next) => {
  try {
    const users = await User.find().select('-password').sort({ createdAt: -1 });
    res.json(users);
  } catch (error) {
    next(error);
  }
};

// Get all technicians with full details
const getAllTechnicians = async (req, res, next) => {
  try {
    const technicians = await User.find({ role: 'technician' })
      .select('-password')
      .sort({ createdAt: -1 });
    res.json({ success: true, data: technicians });
  } catch (error) {
    next(error);
  }
};

// Approve a technician
const approveTechnician = async (req, res, next) => {
  try {
    const tech = await User.findOne({ _id: req.params.id, role: 'technician' });
    if (!tech) return notFound(res, 'Technician');
    tech.isApproved = true;
    tech.accountStatus = 'active';
    if (tech.technicianMeta?.verification) {
      tech.technicianMeta.verification.status = 'verified';
      tech.technicianMeta.verification.aadhaarVerified = true;
    }
    tech.isOnline = true;
    await tech.save();
    res.json({ success: true, message: 'Technician approved', data: tech });
  } catch (error) {
    next(error);
  }
};

// Suspend a technician
const suspendTechnician = async (req, res, next) => {
  try {
    const tech = await User.findOne({ _id: req.params.id, role: 'technician' });
    if (!tech) return notFound(res, 'Technician');
    tech.isApproved = false;
    tech.accountStatus = 'suspended';
    if (tech.technicianMeta?.verification) {
      tech.technicianMeta.verification.status = 'rejected';
      tech.technicianMeta.verification.aadhaarVerified = false;
    }
    tech.isOnline = false;
    await tech.save();
    res.json({ success: true, message: 'Technician suspended', data: tech });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getAllOrders,
  updateOrderStatus,
  getStats,
  getAllUsers,
  assignTechnician,
  getAllTechnicians,
  approveTechnician,
  suspendTechnician,
};
