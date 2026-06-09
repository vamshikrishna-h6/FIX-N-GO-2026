const Rating = require('../models/ratingModel');
const Order = require('../models/orderModel');
const User = require('../models/userModel');
const { parsePagination, paginatedResponse, notFound, forbidden, badRequest } = require('../utils/responseHelpers');

// Create a rating/review
const createRating = async (req, res, next) => {
  try {
    const { orderId, technicianId, rating, review, categories } = req.body;

    if (!orderId || !technicianId || !rating) {
      return badRequest(res, 'Order ID, technician ID, and rating are required');
    }

    if (rating < 1 || rating > 5 || !Number.isInteger(rating)) {
      return badRequest(res, 'Rating must be an integer between 1 and 5');
    }

    // Verify order exists and belongs to customer
    const order = await Order.findById(orderId);
    if (!order) return notFound(res, 'Order');

    if (order.user.toString() !== req.user._id.toString()) {
      return forbidden(res, 'Not authorized to rate this order');
    }

    // Check if order is completed
    if (order.status !== 'completed') {
      return badRequest(res, 'Can only rate completed orders');
    }

    // Check if already rated
    const existingRating = await Rating.findOne({ orderId });
    if (existingRating) {
      return badRequest(res, 'This order has already been rated');
    }

    // Create rating
    const newRating = await Rating.create({
      orderId,
      customerId: req.user._id,
      technicianId,
      rating,
      review: review || '',
      categories: categories || {},
    });

    // Update technician's average rating
    const allRatings = await Rating.find({ technicianId });
    const averageRating =
      allRatings.length > 0
        ? (allRatings.reduce((sum, r) => sum + r.rating, 0) / allRatings.length).toFixed(1)
        : 5.0;

    await User.findByIdAndUpdate(
      technicianId,
      {
        'technicianMeta.averageRating': averageRating,
        'technicianMeta.totalRatings': allRatings.length,
      },
      { new: true }
    );

    res.status(201).json({
      success: true,
      message: 'Rating created successfully',
      data: newRating,
    });
  } catch (error) {
    next(error);
  }
};

// Get all ratings for a technician
const getTechnicianRatings = async (req, res, next) => {
  try {
    const { technicianId } = req.params;
    const { page, limit, skip } = parsePagination(req);

    // Get technician details
    const technician = await User.findById(technicianId);
    if (!technician || technician.role !== 'technician') {
      return notFound(res, 'Technician');
    }

    // Get ratings
    const ratings = await Rating.find({ technicianId })
      .populate('customerId', 'name phone')
      .populate('orderId', 'brand model issues total')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit);

    const total = await Rating.countDocuments({ technicianId });

    paginatedResponse(res, {
      data: ratings.map((r) => ({
        _id: r._id,
        rating: r.rating,
        review: r.review,
        categories: r.categories,
        customer: r.customerId,
        order: r.orderId,
        createdAt: r.createdAt,
      })),
      total,
      page,
      limit,
      extra: {
        technician: {
          _id: technician._id,
          name: technician.name,
          phone: technician.phone,
          averageRating: technician.technicianMeta?.averageRating || 0,
          totalRatings: technician.technicianMeta?.totalRatings || 0,
        },
      },
    });
  } catch (error) {
    next(error);
  }
};

// Get customer's ratings (reviews given)
const getMyRatings = async (req, res, next) => {
  try {
    const { page, limit, skip } = parsePagination(req);

    const ratings = await Rating.find({ customerId: req.user._id })
      .populate('technicianId', 'name phone technicianMeta')
      .populate('orderId', 'brand model issues total')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit);

    const total = await Rating.countDocuments({ customerId: req.user._id });

    paginatedResponse(res, {
      data: ratings.map((r) => ({
        _id: r._id,
        technician: r.technicianId,
        order: r.orderId,
        rating: r.rating,
        review: r.review,
        categories: r.categories,
        createdAt: r.createdAt,
      })),
      total,
      page,
      limit,
    });
  } catch (error) {
    next(error);
  }
};

// Get average rating for a technician
const getTechnicianAverageRating = async (req, res, next) => {
  try {
    const { technicianId } = req.params;

    const technician = await User.findById(technicianId);
    if (!technician || technician.role !== 'technician') {
      return notFound(res, 'Technician');
    }

    const ratings = await Rating.find({ technicianId });

    const averageRating =
      ratings.length > 0 ? (ratings.reduce((sum, r) => sum + r.rating, 0) / ratings.length).toFixed(1) : 0;

    res.json({
      success: true,
      data: {
        technicianId,
        technicianName: technician.name,
        averageRating: parseFloat(averageRating),
        totalRatings: ratings.length,
        distributionCounts: {
          5: ratings.filter((r) => r.rating === 5).length,
          4: ratings.filter((r) => r.rating === 4).length,
          3: ratings.filter((r) => r.rating === 3).length,
          2: ratings.filter((r) => r.rating === 2).length,
          1: ratings.filter((r) => r.rating === 1).length,
        },
      },
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  createRating,
  getTechnicianRatings,
  getMyRatings,
  getTechnicianAverageRating,
};
