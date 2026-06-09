const { authorize } = require('../../middleware/roleMiddleware');

describe('roleMiddleware - authorize', () => {
  let req, res, next;

  beforeEach(() => {
    req = {};
    res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
    };
    next = jest.fn();
  });

  it('returns 401 when req.user is missing', () => {
    const middleware = authorize('admin');
    middleware(req, res, next);
    expect(res.status).toHaveBeenCalledWith(401);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({ message: 'User not authenticated' })
    );
    expect(next).not.toHaveBeenCalled();
  });

  it('returns 403 when user role is not in allowed list', () => {
    req.user = { role: 'customer' };
    const middleware = authorize('admin', 'technician');
    middleware(req, res, next);
    expect(res.status).toHaveBeenCalledWith(403);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({ success: false })
    );
    expect(next).not.toHaveBeenCalled();
  });

  it('calls next when user role is in allowed list', () => {
    req.user = { role: 'admin' };
    const middleware = authorize('admin', 'technician');
    middleware(req, res, next);
    expect(next).toHaveBeenCalled();
    expect(res.status).not.toHaveBeenCalled();
  });

  it('works with a single allowed role', () => {
    req.user = { role: 'technician' };
    const middleware = authorize('technician');
    middleware(req, res, next);
    expect(next).toHaveBeenCalled();
  });

  it('includes role info in denial message', () => {
    req.user = { role: 'customer' };
    const middleware = authorize('admin');
    middleware(req, res, next);
    const body = res.json.mock.calls[0][0];
    expect(body.message).toContain('admin');
    expect(body.message).toContain('customer');
  });
});
