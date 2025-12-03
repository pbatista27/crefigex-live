import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { vendorApi, Vendor } from '../api/vendors';
import { useAuth } from '../context/AuthContext';
import { useToast } from '../hooks/useToast';

const Vendors = () => {
  const { token } = useAuth();
  const [vendors, setVendors] = useState<Vendor[]>([]);
  const [filter, setFilter] = useState<string>('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [rowLoading, setRowLoading] = useState<string | null>(null);
  const { show, Toast } = useToast();

  const badge = (status: string) => {
    const cls =
      status === 'PENDING' ? 'badge pending' : status === 'APPROVED' ? 'badge approved' : 'badge rejected';
    return <span className={cls}>{status}</span>;
  };

  const load = async () => {
    if (!token) return;
    setLoading(true);
    try {
      setError('');
      setVendors(await vendorApi.list(token, filter));
    } catch (err) {
      setError((err as Error).message);
      show('Error cargando vendedores', 'error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    load();
  }, [filter]);

  return (
    <div className="page">
      <div className="card">
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <h2>Vendedores</h2>
            <p style={{ color: 'var(--muted)', margin: 0 }}>Aprueba comerciantes y prestadores de servicio.</p>
          </div>
          <div style={{ display: 'flex', gap: 8 }}>
            <select value={filter} onChange={e => setFilter(e.target.value)} className="pill" style={{ cursor: 'pointer' }}>
              <option value="">Todos</option>
              <option value="PENDING">Pendientes</option>
              <option value="APPROVED">Aprobados</option>
              <option value="REJECTED">Rechazados</option>
            </select>
            <button className="btn secondary" onClick={load} disabled={loading}>
              {loading ? 'Actualizando...' : 'Refrescar'}
            </button>
          </div>
        </div>
        {error && <p style={{ color: '#fca5a5' }}>{error}</p>}
        <table style={{ marginTop: 12 }}>
          <thead>
            <tr>
              <th>Nombre</th>
              <th>Tipo</th>
              <th>Estado</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {vendors.map(v => (
              <tr key={v.id}>
                <td>{v.name}</td>
                <td>{v.vendor_type || '-'}</td>
                <td>{badge(v.status)}</td>
                <td style={{ display: 'flex', gap: 6 }}>
                  <Link to={`/vendors/${v.id}`} className="btn secondary">
                    Revisar
                  </Link>
                  {v.status !== 'APPROVED' && (
                    <button
                      className="btn secondary"
                      disabled={rowLoading === v.id}
                      onClick={async () => {
                        if (!token) return;
                        setRowLoading(v.id);
                        try {
                          await vendorApi.approve(token, v.id);
                          load();
                          show('Vendedor aprobado', 'success');
                        } catch (err) {
                          setError((err as Error).message);
                          show('Error al aprobar', 'error');
                        } finally {
                          setRowLoading(null);
                        }
                      }}
                    >
                      {rowLoading === v.id ? '...' : 'Aprobar'}
                    </button>
                  )}
                  {v.status !== 'REJECTED' && (
                    <button
                      className="btn danger"
                      disabled={rowLoading === v.id}
                      onClick={async () => {
                        if (!token) return;
                        setRowLoading(v.id);
                        try {
                          await vendorApi.reject(token, v.id);
                          load();
                          show('Vendedor rechazado', 'success');
                        } catch (err) {
                          setError((err as Error).message);
                          show('Error al rechazar', 'error');
                        } finally {
                          setRowLoading(null);
                        }
                      }}
                    >
                      {rowLoading === v.id ? '...' : 'Rechazar'}
                    </button>
                  )}
                  <button
                    className="btn secondary"
                    disabled={rowLoading === v.id}
                    onClick={async () => {
                      if (!token) return;
                      setRowLoading(v.id);
                      try {
                        await vendorApi.suspend(token, v.id);
                        load();
                        show('Vendedor suspendido', 'success');
                      } catch (err) {
                        setError((err as Error).message);
                        show('Error al suspender', 'error');
                      } finally {
                        setRowLoading(null);
                      }
                    }}
                  >
                    {rowLoading === v.id ? '...' : 'Suspender'}
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <Toast />
    </div>
  );
};

export default Vendors;
