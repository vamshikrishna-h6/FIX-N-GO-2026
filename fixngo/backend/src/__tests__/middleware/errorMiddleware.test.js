const { errorHandler } = require('../../middleware/errorMiddleware');

describe('errorMiddleware', () => {
  const mockReq = {};
  let mockRes;
  const mockNext = jest.fn();

  beforeEach(() => {
    mockRes = {
      statusCode: 200,
      status: jest.fn().mockReturnThis(),
      json: jest.fn().mockReturnThis(),
    };
  });

  it('defaults to 500 when res.statusCode is 200', () => {
    const err = new Error('Something broke');
    errorHandler(err, mockReq, mockRes, mockNext);
    expect(mockRes.status).toHaveBeenCalledWith(500);
    expect(mockRes.json).toHaveBeenCalledWith(
      expect.objectContaining({ message: 'Something broke' })
    );
  });

  it('preserves non-200 status code', () => {
    mockRes.statusCode = 404;
    const err = new Error('Not found');
    errorHandler(err, mockReq, mockRes, mockNext);
    expect(mockRes.status).toHaveBeenCalledWith(404);
  });

  it('hides stack trace in production', () => {
    const origEnv = process.env.NODE_ENV;
    process.env.NODE_ENV = 'production';
    const err = new Error('Prod error');
    errorHandler(err, mockReq, mockRes, mockNext);
    const body = mockRes.json.mock.calls[0][0];
    expect(body.stack).toBeNull();
    process.env.NODE_ENV = origEnv;
  });

  it('includes stack trace in development', () => {
    const origEnv = process.env.NODE_ENV;
    process.env.NODE_ENV = 'development';
    const err = new Error('Dev error');
    errorHandler(err, mockReq, mockRes, mockNext);
    const body = mockRes.json.mock.calls[0][0];
    expect(body.stack).toBeDefined();
    expect(body.stack).not.toBeNull();
    process.env.NODE_ENV = origEnv;
  });

  it('uses fallback message when err.message is empty', () => {
    const err = new Error();
    err.message = '';
    errorHandler(err, mockReq, mockRes, mockNext);
    const body = mockRes.json.mock.calls[0][0];
    expect(body.message).toBe('Server error');
  });
});
