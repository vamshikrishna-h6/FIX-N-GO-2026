/**
 * Shared response and pagination helpers to eliminate duplicated boilerplate
 * across controllers.
 */

const parsePagination = (req, defaultLimit = 10) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || defaultLimit;
  const skip = (page - 1) * limit;
  return { page, limit, skip };
};

const paginatedResponse = (res, { data, total, page, limit, extra = {} }) => {
  res.json({
    success: true,
    count: data.length,
    total,
    pages: Math.ceil(total / limit),
    page,
    ...extra,
    data,
  });
};

const notFound = (res, resource = 'Resource') =>
  res.status(404).json({ success: false, message: `${resource} not found` });

const forbidden = (res, message = 'Not authorized') =>
  res.status(403).json({ success: false, message });

const badRequest = (res, message) =>
  res.status(400).json({ success: false, message });

module.exports = {
  parsePagination,
  paginatedResponse,
  notFound,
  forbidden,
  badRequest,
};
