describe('smsService', () => {
  const ORIGINAL_ENV = process.env;

  beforeEach(() => {
    jest.resetModules();
    process.env = { ...ORIGINAL_ENV };
    delete process.env.TWILIO_ACCOUNT_SID;
    delete process.env.TWILIO_AUTH_TOKEN;
  });

  afterAll(() => {
    process.env = ORIGINAL_ENV;
  });

  describe('generateOTP', () => {
    it('returns a 6-digit string', () => {
      const { generateOTP } = require('../../utils/smsService');
      const otp = generateOTP();
      expect(otp).toMatch(/^\d{6}$/);
    });

    it('returns values in the valid range', () => {
      const { generateOTP } = require('../../utils/smsService');
      for (let i = 0; i < 50; i++) {
        const num = parseInt(generateOTP(), 10);
        expect(num).toBeGreaterThanOrEqual(100000);
        expect(num).toBeLessThanOrEqual(999999);
      }
    });
  });

  describe('sendOtpSms (mock mode)', () => {
    it('returns success in mock mode when Twilio not configured', async () => {
      const { sendOtpSms } = require('../../utils/smsService');
      const result = await sendOtpSms('9876543210', '123456');
      expect(result.success).toBe(true);
      expect(result.message).toContain('mock mode');
      expect(result.sid).toMatch(/^mock_/);
    });

    it('prepends +91 to numbers without country code', async () => {
      const { sendOtpSms } = require('../../utils/smsService');
      const result = await sendOtpSms('9876543210', '654321');
      expect(result.success).toBe(true);
    });

    it('does not double-prefix numbers that start with +', async () => {
      const { sendOtpSms } = require('../../utils/smsService');
      const result = await sendOtpSms('+919876543210', '654321');
      expect(result.success).toBe(true);
    });
  });
});
