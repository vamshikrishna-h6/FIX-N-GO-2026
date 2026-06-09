const { technicianOnly } = require('../../middleware/technicianMiddleware');

describe('technicianMiddleware - technicianOnly', () => {
  let req, res, next;

  beforeEach(() => {
    req = {};
    res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
    };
    next = jest.fn();
  });

  it('returns 403 when req.user is missing', () => {
    technicianOnly(req, res, next);
    expect(res.status).toHaveBeenCalledWith(403);
    expect(res.json).toHaveBeenCalledWith({ message: 'Technician access only' });
    expect(next).not.toHaveBeenCalled();
  });

  it('returns 403 when user role is customer', () => {
    req.user = { role: 'customer' };
    technicianOnly(req, res, next);
    expect(res.status).toHaveBeenCalledWith(403);
    expect(next).not.toHaveBeenCalled();
  });

  it('returns 403 when user role is admin', () => {
    req.user = { role: 'admin' };
    technicianOnly(req, res, next);
    expect(res.status).toHaveBeenCalledWith(403);
    expect(next).not.toHaveBeenCalled();
  });

  it('calls next when user role is technician', () => {
    req.user = { role: 'technician' };
    technicianOnly(req, res, next);
    expect(next).toHaveBeenCalled();
    expect(res.status).not.toHaveBeenCalled();
  });
});
