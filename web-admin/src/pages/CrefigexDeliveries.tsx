import React, { useEffect, useState } from 'react';
import { API_BASE_URL, authHeaders } from '../api/config';
import { useAuth } from '../context/AuthContext';
import { useToast } from '../hooks/useToast';

const statusBadge = (status: string) => {
  const cls =
    status === 'ENTREGADO'
      ? 'badge approved'
      : status === 'EN_CAMINO'
      ? 'badge pending'
      : 'badge danger';
  return <span className={cls}>{status}</span>;
};

const CrefigexDeliveries: React.FC = () => {
  const { token } = useAuth();
  const [items, setItems] = useState<any[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const { show, Toast } = useToast();

  const load = async () => {
    if (!token) return;
    setLoading(true);
    try {
      setError('');
      const res = await fetch(`${API_BASE_URL}/crefigex/deliveries`, { headers: authHeaders(token) });
      if (!res.ok) throw new Error('Error al cargar entregas');
      const body = await res.json();
      setItems(body.data || body);
    } catch (e) {
      setError((e as Error).message);
      show('Error al sincronizar', 'error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    load();
  }, []);

  const exportCsv = () => {
    const header = 'id,order_id,customer_id,status,delivery_type\n';
    const rows = items.map(d => `${d.id},${d.order_id},${d.customer_id},${d.status},${d.delivery_type}`).join('\n');
    const blob = new Blob([header + rows], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = 'entregas_crefigex.csv';
    link.click();
    URL.revokeObjectURL(url);
    show('Exportado CSV (local)', 'success');
  };

  return (
    <div className="page">
      <div className="card">
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <h2>Entregas Crefigex</h2>
            <p style={{ color: 'var(--muted)', margin: 0 }}>Logística propia sincronizada desde app Entregador.</p>
          </div>
          <div style={{ display: 'flex', gap: 8 }}>
            <button className="btn secondary" onClick={load} disabled={loading}>{loading ? 'Sincronizando...' : 'Sincronizar ahora'}</button>
            <button className="btn secondary" onClick={exportCsv} disabled={!items.length}>Exportar</button>
          </div>
        </div>
        {error && <p style={{ color: '#fca5a5' }}>{error}</p>}
        <table style={{ marginTop: 12 }}>
          <thead>
            <tr>
              <th>Orden</th>
              <th>Cliente</th>
              <th>Estado</th>
              <th>Tipo</th>
            </tr>
          </thead>
          <tbody>
            {items.map(d => (
              <tr key={d.id}>
                <td>{d.order_id}</td>
                <td>{d.customer_id}</td>
                <td>{statusBadge(d.status)}</td>
                <td>{d.delivery_type}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <Toast />
    </div>
  );
};

export default CrefigexDeliveries;
