const Issue = require('../models/issueModel');

const getIssues = async (req, res, next) => {
  try {
    const issues = await Issue.find({}).sort({ createdAt: -1 });
    res.status(200).json({ success: true, count: issues.length, data: issues });
  } catch (error) {
    next(error);
  }
};

const createIssue = async (req, res, next) => {
  try {
    const issue = await Issue.create(req.body);
    res.status(201).json({ success: true, data: issue });
  } catch (error) {
    if (error.name === 'ValidationError') {
      return res.status(400).json({ success: false, message: error.message });
    }
    next(error);
  }
};

module.exports = { getIssues, createIssue };
