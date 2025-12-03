import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { vendorApi, Vendor } from '../api/vendors';
import { useAuth } from '../context/AuthContext';
import { useToast } from '../hooks/useToast';

const VendorDetail = () => {
  const { id } = useParams();
  const { token } = useAuth();
  const [vendor, setVendor] = useState<Vendor | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [actionLoading, setActionLoading] = useState(false);
  const { show, Toast } = useToast();

  const load = async () => {
    if (!token || !id) return;
    setLoading(true);
    try {
      setError('');
      setVendor(await vendorApi.get(token, id));
    } catch (err) {
      setError((err as Error).message);
      show('Error al cargar vendedor', 'error');
    } finally {
      setLoading(false);
    }
  };

  const act = async (fn: (tok: string, id: string) => Promise<any>) => {
    if (!token || !id) return;
    setActionLoading(true);
    try {
      await fn(token, id);
      load();
      show('Acción ejecutada', 'success');
    } catch (err) {
      setError((err as Error).message);
      show('Error en acción', 'error');
    } finally {
      setActionLoading(false);
    }
  };

  useEffect(() => {
    load();
  }, [id]);

  if (loading) return <div className="page"><div className="card">Cargando...</div></div>;
  if (error) return <div className="page"><div className="card" style={{ color: '#fca5a5' }}>{error}</div></div>;
  if (!vendor) return null;
  return (
    <div className="page">
      <div className="card">
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <div className="pill">Vendedor #{id}</div>
            <h2 style={{ margin: '6px 0' }}>{vendor.name}</h2>
            <p style={{ color: 'var(--muted)', margin: 0 }}>Tipo: {vendor.vendor_type || '-'}</p>
          </div>
          <span className="badge pending">{vendor.status}</span>
        </div>
        <div style={{ display: 'grid', gap: 10, marginTop: 18 }}>
          <div className="field">
            <label>Contacto</label>
            <div>{vendor.email || '-'} · {vendor.phone || '-'}</div>
          </div>
        </div>
        <div style={{ display: 'flex', gap: 10, marginTop: 18 }}>
          <button className="btn" disabled={actionLoading} onClick={() => act(vendorApi.approve)}>
            {actionLoading ? '...' : 'Aprobar'}
          </button>
          <button className="btn secondary" disabled={actionLoading} onClick={() => act(vendorApi.reject)}>
            {actionLoading ? '...' : 'Rechazar'}
          </button>
          <button className="btn danger" disabled={actionLoading} onClick={() => act(vendorApi.suspend)}>
            {actionLoading ? '...' : 'Suspender'}
          </button>
        </div>
      </div>
      <Toast />
    </div>
  );
};

export default VendorDetail;
