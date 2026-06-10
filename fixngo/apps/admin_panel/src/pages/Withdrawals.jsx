import { useState, useEffect } from 'react';
import api from '../api';

export default function Withdrawals() {
  const [withdrawals, setWithdrawals] = useState([]);
  const [loading, setLoading] = useState(true);
  const [actionLoading, setActionLoading] = useState(null);

  const reloadWithdrawals = () => {
    setLoading(true);
    return api
      .get('/payments/admin/withdrawals')
      .then((res) => setWithdrawals(res.data.data || []))
      .catch((err) => console.error(err))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    let cancelled = false;

    api
      .get('/payments/admin/withdrawals')
      .then((res) => {
        if (cancelled) return;
        setWithdrawals(res.data.data || []);
      })
      .catch((err) => {
        if (cancelled) return;
        console.error(err);
      })
      .finally(() => {
        if (cancelled) return;
        setLoading(false);
      });

    return () => {
      cancelled = true;
    };
  }, []);

  const handleApprove = async (id) => {
    setActionLoading(id);
    try {
      await api.patch(`/payments/admin/withdrawals/${id}/approve`);
      await reloadWithdrawals();
    } catch (err) {
      console.error(err);
    }
    setActionLoading(null);
  };

  const handleReject = async (id) => {
    setActionLoading(id);
    try {
      await api.patch(`/payments/admin/withdrawals/${id}/reject`);
      await reloadWithdrawals();
    } catch (err) {
      console.error(err);
    }
    setActionLoading(null);
  };

  const statusColor = (status) => {
    switch (status) {
      case 'approved': return 'success';
      case 'rejected': return 'danger';
      case 'pending': return 'warning';
      default: return 'info';
    }
  };

  return (
    <div>
      <h1 style={{ marginBottom: '2rem' }}>Withdrawal Requests</h1>
      <div className="glass-panel table-container">
        <table>
          <thead>
            <tr>
              <th>Technician</th>
              <th>Email</th>
              <th>Amount</th>
              <th>Bank Account</th>
              <th>Status</th>
              <th>Requested</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr><td colSpan="7" style={{ textAlign: 'center', color: 'var(--text-muted)' }}>Loading withdrawals...</td></tr>
            ) : withdrawals.length === 0 ? (
              <tr><td colSpan="7" style={{ textAlign: 'center', color: 'var(--text-muted)' }}>No withdrawal requests.</td></tr>
            ) : (
              withdrawals.map(w => (
                <tr key={w._id}>
                  <td style={{ fontWeight: 600 }}>{w.technician?.name || 'N/A'}</td>
                  <td>{w.technician?.email || '—'}</td>
                  <td style={{ fontFamily: 'monospace', fontWeight: 700 }}>₹{w.amount?.toFixed(2)}</td>
                  <td style={{ fontFamily: 'monospace', fontSize: '0.8rem' }}>{w.bankAccount || '—'}</td>
                  <td>
                    <span className={`badge badge-${statusColor(w.status)}`}>
                      {w.status}
                    </span>
                  </td>
                  <td>{new Date(w.createdAt).toLocaleDateString()}</td>
                  <td style={{ display: 'flex', gap: '0.5rem' }}>
                    {w.status === 'pending' ? (
                      <>
                        <button
                          className="btn btn-outline"
                          style={{ padding: '0.25rem 0.75rem', fontSize: '0.75rem', borderColor: 'var(--success)', color: 'var(--success)' }}
                          onClick={() => handleApprove(w._id)}
                          disabled={actionLoading === w._id}
                        >
                          {actionLoading === w._id ? '...' : 'Approve'}
                        </button>
                        <button
                          className="btn btn-outline"
                          style={{ padding: '0.25rem 0.75rem', fontSize: '0.75rem', borderColor: 'var(--danger)', color: 'var(--danger)' }}
                          onClick={() => handleReject(w._id)}
                          disabled={actionLoading === w._id}
                        >
                          {actionLoading === w._id ? '...' : 'Reject'}
                        </button>
                      </>
                    ) : (
                      <span style={{ color: 'var(--text-muted)', fontSize: '0.8rem' }}>
                        {w.processedAt ? `Processed ${new Date(w.processedAt).toLocaleDateString()}` : '—'}
                      </span>
                    )}
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
