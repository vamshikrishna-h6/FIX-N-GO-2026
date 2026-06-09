// DEPRECATED: use authorize('admin') from roleMiddleware.js instead.
const { authorize } = require('./roleMiddleware');
const adminOnly = authorize('admin');

module.exports = { adminOnly };
