/**
 * Shared technician-to-order assignment logic.
 *
 * Previously duplicated across orderController (dispatchToNearestTechnician,
 * assignTechnicianToOrder) and adminController (assignTechnician).
 */

const User = require('../models/userModel');
const { defaultChecklist, technicianCut, pushStatusHistory } = require('./orderHelpers');
const { emitNotification } = require('./socketService');

/**
 * Core step: populate all assignment-related fields on an order.
 * Does NOT save — caller must persist the order.
 */
const applyAssignment = (order, tech, note) => {
  order.technician = tech.name;
  order.technicianUser = tech._id;
  order.dispatchStatus = 'offered';
  order.status = 'assigned';
  order.technicianEarning = technicianCut(order.total);
  order.checklist = defaultChecklist(order.issues);
  pushStatusHistory(order, 'assigned', note);
};

/**
 * Assign by technician name (string lookup). Used when the customer
 * selects a technician by name during order creation.
 */
const assignByName = async (order, technicianName) => {
  if (!technicianName) return null;

  const tech = await User.findOne({
    role: 'technician',
    name: new RegExp(`^${technicianName.trim()}$`, 'i'),
  });

  if (!tech) return null;

  applyAssignment(order, tech, `Offered to ${tech.name}`);
  return tech;
};

/**
 * Auto-dispatch to the nearest online technician.
 * Returns the matched technician or null.
 */
const dispatchToNearest = async (order) => {
  try {
    const nearestTechs = await User.find({
      role: 'technician',
      isOnline: true,
      location: {
        $nearSphere: {
          $geometry: {
            type: 'Point',
            coordinates: [order.serviceLng, order.serviceLat],
          },
        },
      },
    }).limit(1);

    if (nearestTechs.length === 0) return null;
    const nearest = nearestTechs[0];

    applyAssignment(order, nearest, `System auto-dispatched to ${nearest.name}`);
    await order.save();

    emitNotification(nearest._id.toString(), {
      type: 'new_order_offer',
      title: 'New Job Available!',
      message: `A new repair job for ${order.brand} ${order.model} is available near you.`,
      orderId: order._id,
    });

    return nearest;
  } catch (error) {
    console.error('Auto-dispatch error:', error);
    return null;
  }
};

/**
 * Admin-initiated assignment by technician ObjectId.
 */
const assignById = async (order, technicianId) => {
  const tech = await User.findOne({ _id: technicianId, role: 'technician' });
  if (!tech) return null;

  applyAssignment(order, tech, `Admin assigned to ${tech.name}`);
  await order.save();

  emitNotification(tech._id.toString(), {
    type: 'order_assigned',
    title: 'New Job Assigned',
    message: `Admin has assigned you a new job: ${order.brand} ${order.model}`,
    orderId: order._id,
  });

  return tech;
};

module.exports = {
  applyAssignment,
  assignByName,
  dispatchToNearest,
  assignById,
};
