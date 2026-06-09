const errorHandler = (err, req, res, next) => {
  // Log every error that reaches the global handler
  console.error(
    `[ErrorHandler] ${req.method} ${req.originalUrl} — ${err.name}: ${err.message}`
  );
  if (process.env.NODE_ENV !== 'production') {
    console.error(err.stack);
  }

  // Derive an appropriate status code from the error type
  let statusCode = res.statusCode !== 200 ? res.statusCode : 500;

  if (err.name === 'CastError') {
    // Invalid MongoDB ObjectId
    statusCode = 400;
    err.message = `Invalid ID format: ${err.value}`;
  } else if (err.name === 'ValidationError') {
    // Mongoose validation error
    statusCode = 400;
    const fields = Object.values(err.errors).map((e) => e.message);
    err.message = `Validation failed: ${fields.join(', ')}`;
  } else if (err.code === 11000) {
    // MongoDB duplicate key
    statusCode = 409;
    const field = Object.keys(err.keyValue).join(', ');
    err.message = `Duplicate value for: ${field}`;
  } else if (err.name === 'JsonWebTokenError') {
    statusCode = 401;
    err.message = 'Invalid token';
  } else if (err.name === 'TokenExpiredError') {
    statusCode = 401;
    err.message = 'Token has expired';
  }

  res.status(statusCode).json({
    success: false,
    message: err.message || 'Server error',
    stack: process.env.NODE_ENV === 'production' ? undefined : err.stack,
  });
};

module.exports = { errorHandler };
