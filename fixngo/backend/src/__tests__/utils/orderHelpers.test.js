const {
  HUB_LAT,
  HUB_LNG,
  defaultChecklist,
  technicianCut,
  pushStatusHistory,
  haversineKm,
  assignServiceCoords,
  formatOrderForTech,
} = require('../../utils/orderHelpers');

describe('orderHelpers', () => {
  describe('defaultChecklist', () => {
    it('returns 4 items with default labels when no issues given', () => {
      const list = defaultChecklist();
      expect(list).toHaveLength(4);
      expect(list.every((i) => i.done === false)).toBe(true);
      expect(list[0]).toEqual({ key: 'inspect', label: 'Inspect device', done: false });
      expect(list[1]).toEqual({ key: 'repair', label: 'Complete repair/service', done: false });
      expect(list[2]).toEqual({ key: 'test', label: 'Test and verify', done: false });
      expect(list[3]).toEqual({ key: 'payment', label: 'Collect payment', done: false });
    });

    it('returns 4 items when empty array given', () => {
      const list = defaultChecklist([]);
      expect(list).toHaveLength(4);
      expect(list[1].label).toBe('Complete repair/service');
    });

    it('overrides the repair label with the first issue', () => {
      const list = defaultChecklist(['Screen Replacement', 'Battery Repair']);
      expect(list[1].label).toBe('Service: Screen Replacement');
    });
  });

  describe('technicianCut', () => {
    it('returns 70% of the total, rounded', () => {
      expect(technicianCut(1000)).toBe(700);
      expect(technicianCut(999)).toBe(699);
      expect(technicianCut(0)).toBe(0);
    });

    it('rounds fractional amounts', () => {
      expect(technicianCut(101)).toBe(71);
      expect(technicianCut(33)).toBe(23);
    });
  });

  describe('pushStatusHistory', () => {
    it('creates statusHistory array if missing and appends entry', () => {
      const order = {};
      pushStatusHistory(order, 'pending', 'Order created');
      expect(order.statusHistory).toHaveLength(1);
      expect(order.statusHistory[0].status).toBe('pending');
      expect(order.statusHistory[0].note).toBe('Order created');
      expect(order.statusHistory[0].at).toBeInstanceOf(Date);
    });

    it('appends to existing statusHistory', () => {
      const order = { statusHistory: [{ status: 'pending', note: '', at: new Date() }] };
      pushStatusHistory(order, 'assigned');
      expect(order.statusHistory).toHaveLength(2);
      expect(order.statusHistory[1].status).toBe('assigned');
      expect(order.statusHistory[1].note).toBe('');
    });
  });

  describe('haversineKm', () => {
    it('returns 0 for identical coordinates', () => {
      expect(haversineKm(17.385, 78.4867, 17.385, 78.4867)).toBe(0);
    });

    it('computes a known distance (Hyderabad to Secunderabad ~10 km)', () => {
      const dist = haversineKm(17.385, 78.4867, 17.4399, 78.4983);
      expect(dist).toBeGreaterThan(5);
      expect(dist).toBeLessThan(15);
    });

    it('is symmetric', () => {
      const d1 = haversineKm(17.385, 78.4867, 18.0, 79.0);
      const d2 = haversineKm(18.0, 79.0, 17.385, 78.4867);
      expect(d1).toBeCloseTo(d2, 6);
    });

    it('handles zero-crossing meridian', () => {
      const dist = haversineKm(0, -1, 0, 1);
      expect(dist).toBeGreaterThan(200);
      expect(dist).toBeLessThan(230);
    });
  });

  describe('assignServiceCoords', () => {
    it('assigns coords near HUB when serviceLat/Lng are null', () => {
      const order = { _id: { toString: () => 'abc123' }, serviceLat: null, serviceLng: null };
      assignServiceCoords(order);
      expect(order.serviceLat).toBeCloseTo(HUB_LAT, 0);
      expect(order.serviceLng).toBeCloseTo(HUB_LNG, 0);
    });

    it('does not overwrite existing coords', () => {
      const order = { serviceLat: 10.0, serviceLng: 20.0 };
      assignServiceCoords(order);
      expect(order.serviceLat).toBe(10.0);
      expect(order.serviceLng).toBe(20.0);
    });

    it('produces deterministic output for the same seed', () => {
      const o1 = { serviceLat: null, serviceLng: null };
      const o2 = { serviceLat: null, serviceLng: null };
      assignServiceCoords(o1, 'seed42');
      assignServiceCoords(o2, 'seed42');
      expect(o1.serviceLat).toBe(o2.serviceLat);
      expect(o1.serviceLng).toBe(o2.serviceLng);
    });

    it('produces different output for different seeds', () => {
      const o1 = { serviceLat: null, serviceLng: null };
      const o2 = { serviceLat: null, serviceLng: null };
      assignServiceCoords(o1, 'seedA');
      assignServiceCoords(o2, 'seedB');
      // Very unlikely to be identical for different seeds
      expect(o1.serviceLat === o2.serviceLat && o1.serviceLng === o2.serviceLng).toBe(false);
    });
  });

  describe('formatOrderForTech', () => {
    const baseOrder = {
      _id: { toString: () => '665a1234abcd5678ef901234' },
      brand: 'Samsung',
      model: 'Galaxy S25',
      issues: ['Screen Replacement'],
      total: 1000,
      status: 'pending',
      dispatchStatus: 'none',
      checklist: [],
      paymentStatus: 'pending',
      serviceAddress: '123 Main St',
      city: 'Hyderabad',
      pincode: '500001',
      serviceLat: 17.385,
      serviceLng: 78.4867,
      technicianEarning: 700,
      createdAt: new Date('2026-01-01'),
      updatedAt: new Date('2026-01-01'),
      user: { name: 'Test Customer', phone: '9876543210' },
      customerPhone: '9876543210',
    };

    it('formats order with correct fields', () => {
      const result = formatOrderForTech(baseOrder);
      expect(result.jobId).toBe('#1234');
      expect(result.device).toBe('Samsung Galaxy S25');
      expect(result.customerName).toBe('Test Customer');
      expect(result.earning).toBe(700);
      expect(result.title).toBe('Screen Replacement');
    });

    it('computes distance when technician location is available', () => {
      const tech = { lastLat: 17.44, lastLng: 78.50 };
      const result = formatOrderForTech(baseOrder, tech);
      expect(result.distanceKm).toBeGreaterThan(0);
      expect(typeof result.distanceKm).toBe('number');
    });

    it('returns null distance when technician location is missing', () => {
      const result = formatOrderForTech(baseOrder);
      expect(result.distanceKm).toBeNull();
    });

    it('returns null distance when order coords are missing', () => {
      const order = { ...baseOrder, serviceLat: null, serviceLng: null };
      const tech = { lastLat: 17.44, lastLng: 78.50 };
      const result = formatOrderForTech(order, tech);
      expect(result.distanceKm).toBeNull();
    });

    it('falls back to technicianCut when technicianEarning is 0', () => {
      const order = { ...baseOrder, technicianEarning: 0 };
      const result = formatOrderForTech(order);
      expect(result.earning).toBe(700); // 70% of 1000
    });

    it('falls back to "Customer" and empty phone when user is missing', () => {
      const order = { ...baseOrder, user: null, customerPhone: '' };
      const result = formatOrderForTech(order);
      expect(result.customerName).toBe('Customer');
      expect(result.customerPhone).toBe('');
    });

    it('uses first issue as title, or default', () => {
      const order = { ...baseOrder, issues: [] };
      const result = formatOrderForTech(order);
      expect(result.title).toBe('Repair service');
    });
  });

  describe('constants', () => {
    it('exports hub coordinates', () => {
      expect(typeof HUB_LAT).toBe('number');
      expect(typeof HUB_LNG).toBe('number');
      expect(HUB_LAT).toBeCloseTo(17.46, 1);
      expect(HUB_LNG).toBeCloseTo(78.37, 1);
    });
  });
});
