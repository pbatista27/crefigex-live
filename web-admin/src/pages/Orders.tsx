import { useEffect, useState } from 'react';
import { ordersApi, AdminOrder } from '../api/orders';
import { useAuth } from '../context/AuthContext';
import { useToast } from '../hooks/useToast';

const Orders = () => {
  const { token } = useAuth();
  const { show, Toast } = useToast();
  const [orders, setOrders] = useState<AdminOrder[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const badge = (status: string) => {
    const cls =
      status === 'APPROVED' ? 'badge approved' : status === 'PENDING' ? 'badge pending' : 'badge rejected';
    return <span className={cls}>{status}</span>;
  };

  const load = async () => {
    if (!token) return;
    setLoading(true);
    try {
      setError('');
      const data = await ordersApi.listAdmin(token);
      setOrders(data);
    } catch (e) {
      const msg = (e as Error).message;
      setError(msg);
      show(msg, 'error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    load();
  }, []);

  return (
    <div className="page">
      <div className="card">
        <h2>Ventas BNPL</h2>
        <p style={{ color: 'var(--muted)', marginTop: 4 }}>Órdenes, planes de pago y estados de aprobación.</p>
        <div style={{ display: 'flex', gap: 10, marginBottom: 10 }}>
          <button className="btn secondary" onClick={load} disabled={loading}>
            {loading ? 'Cargando...' : 'Refrescar'}
          </button>
        </div>
        {error && <p style={{ color: '#fca5a5' }}>{error}</p>}
        <table style={{ marginTop: 12 }}>
          <thead>
            <tr>
              <th>ID</th>
              <th>Cliente</th>
              <th>Vendedor</th>
              <th>Plan</th>
              <th>Monto</th>
              <th>Estado</th>
            </tr>
          </thead>
          <tbody>
            {orders.map(o => (
              <tr key={o.id}>
                <td>{o.id}</td>
                <td>{o.customer_name || '-'}</td>
                <td>{o.vendor_name || '-'}</td>
                <td>{o.payment_plan || '-'}</td>
                <td>${o.total_amount ?? 0}</td>
                <td>{badge(o.status)}</td>
              </tr>
            ))}
            {!orders.length && !loading && (
              <tr>
                <td colSpan={6} style={{ textAlign: 'center', color: 'var(--muted)' }}>
                  Sin órdenes registradas.
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
      <Toast />
    </div>
  );
};

export default Orders;
