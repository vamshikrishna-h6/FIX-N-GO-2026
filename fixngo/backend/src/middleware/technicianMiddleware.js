// DEPRECATED: use authorize('technician') from roleMiddleware.js instead.
const { authorize } = require('./roleMiddleware');
const technicianOnly = authorize('technician');

module.exports = { technicianOnly };
