jest.mock('../../models/userModel');
jest.mock('../../models/otpModel');
jest.mock('../../models/passwordResetModel');
jest.mock('../../models/refreshTokenModel');
jest.mock('../../utils/emailService');
jest.mock('../../utils/smsService');

const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

describe('authController', () => {
  const ORIGINAL_ENV = process.env;

  beforeEach(() => {
    jest.resetModules();
    process.env = { ...ORIGINAL_ENV, JWT_SECRET: 'test-secret' };
  });

  afterAll(() => {
    process.env = ORIGINAL_ENV;
  });

  describe('registerUser', () => {
    let req, res, next, registerUser;

    beforeEach(() => {
      jest.resetModules();
      process.env = { ...ORIGINAL_ENV, JWT_SECRET: 'test-secret' };
      jest.mock('../../models/userModel');
      jest.mock('../../models/otpModel');
      jest.mock('../../models/passwordResetModel');
      jest.mock('../../models/refreshTokenModel');
      jest.mock('../../utils/emailService');
      jest.mock('../../utils/smsService');

      const authController = require('../../controllers/authController');
      registerUser = authController.registerUser;

      req = { body: {} };
      res = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn().mockReturnThis(),
      };
      next = jest.fn();
    });

    it('returns 400 when name is missing', async () => {
      req.body = { email: 'a@b.com', password: 'password123' };
      await registerUser(req, res, next);
      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('returns 400 when email is missing', async () => {
      req.body = { name: 'Test', password: 'password123' };
      await registerUser(req, res, next);
      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('returns 400 when password is missing', async () => {
      req.body = { name: 'Test', email: 'a@b.com' };
      await registerUser(req, res, next);
      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('returns 409 when user already exists', async () => {
      const User = require('../../models/userModel');
      User.findOne.mockResolvedValue({ _id: 'existing' });
      req.body = { name: 'Test', email: 'existing@test.com', password: 'password123' };
      await registerUser(req, res, next);
      expect(res.status).toHaveBeenCalledWith(409);
    });

    it('creates customer by default when no role specified', async () => {
      const User = require('../../models/userModel');
      const RefreshToken = require('../../models/refreshTokenModel');
      User.findOne.mockResolvedValue(null);
      const fakeUser = {
        _id: 'newuser',
        name: 'Test',
        email: 'new@test.com',
        role: 'customer',
        accountStatus: 'active',
        isApproved: true,
        phone: '',
        address: '',
        city: 'Hyderabad',
        pincode: '',
        profilePhoto: '',
        isOnline: false,
        customerMeta: {},
      };
      User.create.mockResolvedValue(fakeUser);
      RefreshToken.create.mockResolvedValue({ token: 'refresh-token-123' });

      req.body = { name: 'Test', email: 'new@test.com', password: 'password123' };
      await registerUser(req, res, next);
      expect(res.status).toHaveBeenCalledWith(201);
      const responseBody = res.json.mock.calls[0][0];
      expect(responseBody._id).toBe('newuser');
      expect(responseBody.token).toBeDefined();
    });
  });

  describe('loginUser', () => {
    let req, res, next, loginUser;

    beforeEach(() => {
      jest.resetModules();
      process.env = { ...ORIGINAL_ENV, JWT_SECRET: 'test-secret' };
      jest.mock('../../models/userModel');
      jest.mock('../../models/otpModel');
      jest.mock('../../models/passwordResetModel');
      jest.mock('../../models/refreshTokenModel');
      jest.mock('../../utils/emailService');
      jest.mock('../../utils/smsService');

      const authController = require('../../controllers/authController');
      loginUser = authController.loginUser;

      req = { body: {} };
      res = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn().mockReturnThis(),
      };
      next = jest.fn();
    });

    it('returns 400 when email is missing', async () => {
      req.body = { password: 'password123' };
      await loginUser(req, res, next);
      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('returns 400 when password is missing', async () => {
      req.body = { email: 'a@b.com' };
      await loginUser(req, res, next);
      expect(res.status).toHaveBeenCalledWith(400);
    });

    it('returns 401 when user not found', async () => {
      const User = require('../../models/userModel');
      User.findOne.mockResolvedValue(null);
      req.body = { email: 'nonexistent@test.com', password: 'password123' };
      await loginUser(req, res, next);
      expect(res.status).toHaveBeenCalledWith(401);
    });

    it('returns 403 when role mismatch', async () => {
      const User = require('../../models/userModel');
      User.findOne.mockResolvedValue({ _id: 'u1', role: 'customer', password: 'hashed' });
      req.body = { email: 'a@b.com', password: 'password123', role: 'technician' };
      await loginUser(req, res, next);
      expect(res.status).toHaveBeenCalledWith(403);
    });

    it('returns 401 when password does not match', async () => {
      const User = require('../../models/userModel');
      User.findOne.mockResolvedValue({
        _id: 'u1',
        role: 'customer',
        password: await bcrypt.hash('correctpassword', 10),
      });
      req.body = { email: 'a@b.com', password: 'wrongpassword' };
      await loginUser(req, res, next);
      expect(res.status).toHaveBeenCalledWith(401);
    });
  });

  describe('getProfile', () => {
    let req, res, next, getProfile;

    beforeEach(() => {
      jest.resetModules();
      process.env = { ...ORIGINAL_ENV, JWT_SECRET: 'test-secret' };
      jest.mock('../../models/userModel');
      jest.mock('../../models/otpModel');
      jest.mock('../../models/passwordResetModel');
      jest.mock('../../models/refreshTokenModel');
      jest.mock('../../utils/emailService');
      jest.mock('../../utils/smsService');

      const authController = require('../../controllers/authController');
      getProfile = authController.getProfile;

      req = {};
      res = {
        status: jest.fn().mockReturnThis(),
        json: jest.fn().mockReturnThis(),
      };
      next = jest.fn();
    });

    it('returns 401 when req.user is missing', async () => {
      await getProfile(req, res, next);
      expect(res.status).toHaveBeenCalledWith(401);
    });

    it('returns user profile when req.user exists', async () => {
      const User = require('../../models/userModel');
      const fakeUser = {
        _id: 'u1',
        name: 'Test',
        email: 'test@test.com',
        role: 'customer',
        accountStatus: 'active',
        isApproved: true,
        phone: '1234567890',
        address: '123 St',
        city: 'Hyderabad',
        pincode: '500001',
        profilePhoto: '',
        isOnline: false,
        customerMeta: {},
        notificationPrefs: {},
      };
      User.findById.mockReturnValue({ select: jest.fn().mockResolvedValue(fakeUser) });
      req.user = { _id: 'u1' };
      await getProfile(req, res, next);
      expect(res.json).toHaveBeenCalled();
    });
  });
});
