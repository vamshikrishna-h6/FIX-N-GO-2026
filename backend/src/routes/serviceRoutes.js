const express = require('express');
const { getIssues, createIssue } = require('../controllers/serviceController');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

router.route('/issues').get(getIssues).post(protect, createIssue);

module.exports = router;
