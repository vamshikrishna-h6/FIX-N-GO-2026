const SupportTicket = require('../models/supportTicketModel');

const createSupportTicket = async (req, res, next) => {
  try {
    const { subject, message, category, priority, orderId } = req.body;

    if (!subject || !message) {
      return res.status(400).json({ success: false, message: 'Subject and message are required' });
    }

    const ticket = await SupportTicket.create({
      createdBy: req.user._id,
      role: req.user.role,
      subject,
      message,
      category: category || 'general',
      priority: priority || 'medium',
      orderId: orderId || null,
    });

    res.status(201).json({ success: true, data: ticket });
  } catch (error) {
    next(error);
  }
};

const getMySupportTickets = async (req, res, next) => {
  try {
    const tickets = await SupportTicket.find({ createdBy: req.user._id }).sort({ createdAt: -1 });
    res.json({ success: true, data: tickets });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  createSupportTicket,
  getMySupportTickets,
};