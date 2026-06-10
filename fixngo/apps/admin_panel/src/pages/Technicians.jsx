import { useState, useEffect } from 'react';
import api from '../api';

export default function Technicians() {
  const [technicians, setTechnicians] = useState([]);
  const [loading, setLoading] = useState(true);
  const [actionLoading, setActionLoading] = useState(null);

  const reloadTechnicians = () => {
    setLoading(true);
    return api
      .get('/admin/technicians')
      .then((res) => setTechnicians(res.data.data || []))
      .catch((err) => console.error(err))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    let cancelled = false;

    api
      .get('/admin/technicians')
      .then((res) => {
        if (cancelled) return;
        setTechnicians(res.data.data || []);
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
      await api.patch(`/admin/technicians/${id}/approve`);
      await reloadTechnicians();
    } catch (err) {
      console.error(err);
    }
    setActionLoading(null);
  };

  const handleSuspend = async (id) => {
    setActionLoading(id);
    try {
      await api.patch(`/admin/technicians/${id}/suspend`);
      await reloadTechnicians();
    } catch (err) {
      console.error(err);
    }
    setActionLoading(null);
  };

  return (
    <div>
      <h1 style={{ marginBottom: '2rem' }}>Technician Management</h1>
      <div className="glass-panel table-container">
        <table>
          <thead>
            <tr>
              <th>Name</th>
              <th>Email</th>
              <th>Phone</th>
              <th>Status</th>
              <th>Rating</th>
              <th>Jobs Done</th>
              <th>Wallet</th>
              <th>Joined</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr><td colSpan="9" style={{ textAlign: 'center', color: 'var(--text-muted)' }}>Loading technicians...</td></tr>
            ) : technicians.length === 0 ? (
              <tr><td colSpan="9" style={{ textAlign: 'center', color: 'var(--text-muted)' }}>No technicians found.</td></tr>
            ) : (
              technicians.map(tech => (
                <tr key={tech._id}>
                  <td style={{ fontWeight: 600 }}>{tech.name || 'N/A'}</td>
                  <td>{tech.email}</td>
                  <td>{tech.phone || '—'}</td>
                  <td>
                    <span className={`badge badge-${tech.isApproved !== false ? 'success' : 'warning'}`}>
                      {tech.isApproved !== false ? 'Approved' : 'Pending'}
                    </span>
                    {tech.isOnline && (
                      <span className="badge badge-info" style={{ marginLeft: '0.25rem', fontSize: '0.65rem' }}>Online</span>
                    )}
                  </td>
                  <td>{tech.technicianMeta?.rating?.toFixed(1) || '—'}</td>
                  <td>{tech.technicianMeta?.jobsDone || 0}</td>
                  <td>₹{(tech.technicianMeta?.walletBalance || 0).toFixed(2)}</td>
                  <td>{new Date(tech.createdAt).toLocaleDateString()}</td>
                  <td style={{ display: 'flex', gap: '0.5rem' }}>
                    {tech.isApproved === false ? (
                      <button
                        className="btn btn-outline"
                        style={{ padding: '0.25rem 0.75rem', fontSize: '0.75rem', borderColor: 'var(--success)', color: 'var(--success)' }}
                        onClick={() => handleApprove(tech._id)}
                        disabled={actionLoading === tech._id}
                      >
                        {actionLoading === tech._id ? '...' : 'Approve'}
                      </button>
                    ) : (
                      <button
                        className="btn btn-outline"
                        style={{ padding: '0.25rem 0.75rem', fontSize: '0.75rem', borderColor: 'var(--danger)', color: 'var(--danger)' }}
                        onClick={() => handleSuspend(tech._id)}
                        disabled={actionLoading === tech._id}
                      >
                        {actionLoading === tech._id ? '...' : 'Suspend'}
                      </button>
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
