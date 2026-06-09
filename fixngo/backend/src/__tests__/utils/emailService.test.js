describe('emailService', () => {
  const ORIGINAL_ENV = process.env;

  beforeEach(() => {
    jest.resetModules();
    process.env = { ...ORIGINAL_ENV };
    delete process.env.SMTP_USER;
    delete process.env.SMTP_PASS;
  });

  afterAll(() => {
    process.env = ORIGINAL_ENV;
  });

  describe('generateOTP', () => {
    it('returns a 6-digit string', () => {
      const { generateOTP } = require('../../utils/emailService');
      const otp = generateOTP();
      expect(otp).toMatch(/^\d{6}$/);
    });

    it('returns a value between 100000 and 999999', () => {
      const { generateOTP } = require('../../utils/emailService');
      for (let i = 0; i < 50; i++) {
        const num = parseInt(generateOTP(), 10);
        expect(num).toBeGreaterThanOrEqual(100000);
        expect(num).toBeLessThanOrEqual(999999);
      }
    });
  });

  describe('generateResetToken', () => {
    it('returns a 64-char hex string', () => {
      const { generateResetToken } = require('../../utils/emailService');
      const token = generateResetToken();
      expect(token).toMatch(/^[0-9a-f]{64}$/);
    });

    it('generates unique tokens', () => {
      const { generateResetToken } = require('../../utils/emailService');
      const t1 = generateResetToken();
      const t2 = generateResetToken();
      expect(t1).not.toBe(t2);
    });
  });

  describe('sendPasswordResetEmail (mock mode)', () => {
    it('returns success in mock mode when SMTP not configured', async () => {
      const { sendPasswordResetEmail } = require('../../utils/emailService');
      const result = await sendPasswordResetEmail('test@example.com', '123456', 'Test User');
      expect(result.success).toBe(true);
      expect(result.message).toContain('mock mode');
    });
  });
});
