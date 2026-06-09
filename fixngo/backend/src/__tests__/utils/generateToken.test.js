const jwt = require('jsonwebtoken');

describe('generateToken', () => {
  const ORIGINAL_ENV = process.env;

  beforeEach(() => {
    jest.resetModules();
    process.env = { ...ORIGINAL_ENV, JWT_SECRET: 'test-secret-key' };
  });

  afterAll(() => {
    process.env = ORIGINAL_ENV;
  });

  it('returns a valid JWT containing id and role', () => {
    const generateToken = require('../../utils/generateToken');
    const token = generateToken('user123', 'customer');
    const decoded = jwt.verify(token, 'test-secret-key');
    expect(decoded.id).toBe('user123');
    expect(decoded.role).toBe('customer');
  });

  it('sets expiry to 7 days', () => {
    const generateToken = require('../../utils/generateToken');
    const token = generateToken('user123', 'technician');
    const decoded = jwt.verify(token, 'test-secret-key');
    const sevenDays = 7 * 24 * 60 * 60;
    expect(decoded.exp - decoded.iat).toBe(sevenDays);
  });

  it('throws when JWT_SECRET is not set', () => {
    delete process.env.JWT_SECRET;
    const generateToken = require('../../utils/generateToken');
    expect(() => generateToken('user123', 'admin')).toThrow('JWT_SECRET environment variable is not set');
  });

  it('generates different tokens for different users', () => {
    const generateToken = require('../../utils/generateToken');
    const t1 = generateToken('user1', 'customer');
    const t2 = generateToken('user2', 'customer');
    expect(t1).not.toBe(t2);
  });
});
