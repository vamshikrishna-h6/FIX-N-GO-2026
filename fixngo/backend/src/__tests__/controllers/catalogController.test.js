jest.mock('../../models/serviceModel');

const Service = require('../../models/serviceModel');
const { getCatalog } = require('../../controllers/catalogController');

describe('catalogController - getCatalog', () => {
  let req, res, next;

  beforeEach(() => {
    req = {};
    res = {
      json: jest.fn(),
    };
    next = jest.fn();
    jest.clearAllMocks();
  });

  it('returns brands and default issues when no services in DB', async () => {
    Service.find.mockReturnValue({ sort: jest.fn().mockResolvedValue([]) });
    await getCatalog(req, res, next);
    expect(res.json).toHaveBeenCalledWith(
      expect.objectContaining({
        brands: expect.arrayContaining([
          expect.objectContaining({ name: 'Samsung' }),
          expect.objectContaining({ name: 'Apple' }),
          expect.objectContaining({ name: 'OnePlus' }),
        ]),
        issues: expect.arrayContaining([
          expect.objectContaining({ name: 'Screen Replacement', emoji: expect.any(String), price: 999 }),
          expect.objectContaining({ name: 'Battery Repair', price: 799 }),
          expect.objectContaining({ name: 'Camera Repair', price: 899 }),
          expect.objectContaining({ name: 'Software Fix', price: 499 }),
        ]),
      })
    );
  });

  it('returns services from DB when available', async () => {
    const dbServices = [
      { title: 'Screen Fix', description: 'Fix screen', price: 500, _id: 'svc1' },
      { title: 'Battery Swap', description: 'Replace battery', price: 300, _id: 'svc2' },
    ];
    Service.find.mockReturnValue({ sort: jest.fn().mockResolvedValue(dbServices) });
    await getCatalog(req, res, next);
    const response = res.json.mock.calls[0][0];
    expect(response.issues).toHaveLength(2);
    expect(response.issues[0].name).toBe('Screen Fix');
    expect(response.issues[0].emoji).toBe('\uD83E\uDDE9'); // screen emoji
    expect(response.issues[1].name).toBe('Battery Swap');
    expect(response.issues[1].emoji).toBe('\uD83D\uDD0B'); // battery emoji
  });

  it('assigns camera emoji for camera-related services', async () => {
    const dbServices = [
      { title: 'Camera Lens Repair', description: 'Fix lens', price: 600, _id: 'svc3' },
    ];
    Service.find.mockReturnValue({ sort: jest.fn().mockResolvedValue(dbServices) });
    await getCatalog(req, res, next);
    const response = res.json.mock.calls[0][0];
    expect(response.issues[0].emoji).toBe('\uD83D\uDCF7'); // camera emoji
  });

  it('assigns default emoji for unknown service types', async () => {
    const dbServices = [
      { title: 'General Checkup', description: 'Checkup', price: 200, _id: 'svc4' },
    ];
    Service.find.mockReturnValue({ sort: jest.fn().mockResolvedValue(dbServices) });
    await getCatalog(req, res, next);
    const response = res.json.mock.calls[0][0];
    expect(response.issues[0].emoji).toBe('\uD83C\uDF00'); // cyclone/default emoji
  });

  it('calls next on database error', async () => {
    const dbError = new Error('DB connection failed');
    Service.find.mockReturnValue({ sort: jest.fn().mockRejectedValue(dbError) });
    await getCatalog(req, res, next);
    expect(next).toHaveBeenCalledWith(dbError);
    expect(res.json).not.toHaveBeenCalled();
  });
});
