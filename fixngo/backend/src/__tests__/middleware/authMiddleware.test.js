const jwt = require('jsonwebtoken');

jest.mock('../../models/userModel');

const User = require('../../models/userModel');
const { protect } = require('../../middleware/authMiddleware');

describe('authMiddleware - protect', () => {
  const SECRET = 'test-secret';
  let req, res, next;

  beforeAll(() => {
    process.env.JWT_SECRET = SECRET;
  });

  beforeEach(() => {
    req = { headers: {} };
    res = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
    };
    next = jest.fn();
    jest.clearAllMocks();
  });

  it('returns 401 when no authorization header', async () => {
    await protect(req, res, next);
    expect(res.status).toHaveBeenCalledWith(401);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({ message: 'Not authorized, token missing' })
    );
    expect(next).not.toHaveBeenCalled();
  });

  it('returns 401 when authorization header does not start with Bearer', async () => {
    req.headers.authorization = 'Basic abc123';
    await protect(req, res, next);
    expect(res.status).toHaveBeenCalledWith(401);
    expect(next).not.toHaveBeenCalled();
  });

  it('returns 401 for invalid token', async () => {
    req.headers.authorization = 'Bearer invalid.token.here';
    await protect(req, res, next);
    expect(res.status).toHaveBeenCalledWith(401);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({ message: 'Not authorized, token invalid' })
    );
  });

  it('returns 401 when user not found', async () => {
    const token = jwt.sign({ id: 'user123', role: 'customer' }, SECRET, { expiresIn: '1h' });
    req.headers.authorization = `Bearer ${token}`;
    User.findById.mockReturnValue({ select: jest.fn().mockResolvedValue(null) });
    await protect(req, res, next);
    expect(res.status).toHaveBeenCalledWith(401);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({ message: 'Not authorized, user not found' })
    );
  });

  it('sets req.user and calls next on valid token', async () => {
    const fakeUser = { _id: 'user123', name: 'Test', role: 'customer' };
    const token = jwt.sign({ id: 'user123', role: 'customer' }, SECRET, { expiresIn: '1h' });
    req.headers.authorization = `Bearer ${token}`;
    User.findById.mockReturnValue({ select: jest.fn().mockResolvedValue(fakeUser) });
    await protect(req, res, next);
    expect(req.user).toEqual(fakeUser);
    expect(next).toHaveBeenCalled();
  });

  it('returns 500 when JWT_SECRET is missing', async () => {
    const origSecret = process.env.JWT_SECRET;
    delete process.env.JWT_SECRET;
    req.headers.authorization = 'Bearer some.valid.token';
    await protect(req, res, next);
    expect(res.status).toHaveBeenCalledWith(500);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({ message: 'Server misconfiguration' })
    );
    process.env.JWT_SECRET = origSecret;
  });
});
