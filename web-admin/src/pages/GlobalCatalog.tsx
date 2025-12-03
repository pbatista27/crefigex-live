import React, { useEffect, useState } from 'react';
import { API_BASE_URL, authHeaders } from '../api/config';
import { useAuth } from '../context/AuthContext';
import { useToast } from '../hooks/useToast';
import { catalogApi } from '../api/catalog';
import { globalCatalogApi } from '../api/globalCatalog';

type CatalogItem = {
  id: string;
  name: string;
  vendor_id?: string;
  category_id?: string;
  active?: boolean;
  type: 'PRODUCTO' | 'SERVICIO';
};

const GlobalCatalog: React.FC = () => {
  const { token } = useAuth();
  const [items, setItems] = useState<CatalogItem[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const { show, Toast } = useToast();
  const [showForm, setShowForm] = useState(false);
  const [isService, setIsService] = useState(false);
  const [form, setForm] = useState({ name: '', vendor_id: '', price: 0, category_id: '', service_type: '' });
  const [editingId, setEditingId] = useState<string | null>(null);

  const load = async () => {
    if (!token) return;
    setLoading(true);
    try {
      setError('');
      const [products, services] = await Promise.all([
        fetch(`${API_BASE_URL}/catalog/products`, { headers: authHeaders(token) }).then(r => r.json()),
        fetch(`${API_BASE_URL}/catalog/services`, { headers: authHeaders(token) }).then(r => r.json()),
      ]);
      const mapped: CatalogItem[] = [
        ...((products.data || products) as any[]).map((p: any) => ({ ...p, type: 'PRODUCTO' as const })),
        ...((services.data || services) as any[]).map((s: any) => ({ ...s, type: 'SERVICIO' as const })),
      ];
      setItems(mapped);
    } catch (e) {
      setError((e as Error).message);
      show('Error cargando catálogo', 'error');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    load();
  }, []);

  const exportCsv = () => {
    const header = 'id,name,vendor_id,category_id,type\n';
  const rows = items.map(i => `${i.id},${i.name},${i.vendor_id ?? ''},${i.category_id ?? ''},${i.type}`).join('\n');
    const csv = header + rows;
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = 'catalogo_crefigex.csv';
    link.click();
    URL.revokeObjectURL(url);
    show('Exportado CSV (local)', 'success');
  };

  const openForm = (service: boolean, item?: CatalogItem) => {
    setIsService(service);
    if (item) {
      setEditingId(item.id);
      setForm({
        name: item.name,
        vendor_id: item.vendor_id || '',
        price: 0,
        category_id: item.category_id || '',
        service_type: '',
      });
    } else {
      setEditingId(null);
      setForm({ name: '', vendor_id: '', price: 0, category_id: '', service_type: '' });
    }
    setShowForm(true);
  };

  const submitForm = async () => {
    if (!token) return;
    try {
      if (isService) {
        if (editingId) {
          await globalCatalogApi.updateService(token, editingId, {
            vendor_id: form.vendor_id,
            name: form.name,
            price: form.price,
            service_type: form.service_type,
            description: '',
            currency: 'USD',
          });
        } else {
          await globalCatalogApi.createService(token, {
            vendor_id: form.vendor_id,
            name: form.name,
            price: form.price,
            service_type: form.service_type,
            description: '',
            currency: 'USD',
          });
        }
      } else {
        if (editingId) {
          await globalCatalogApi.updateProduct(token, editingId, {
            vendor_id: form.vendor_id,
            name: form.name,
            price: form.price,
            category_id: form.category_id,
            description: '',
            currency: 'USD',
          });
        } else {
          await globalCatalogApi.createProduct(token, {
            vendor_id: form.vendor_id,
            name: form.name,
            price: form.price,
            category_id: form.category_id,
            description: '',
            currency: 'USD',
          });
        }
      }
      show(editingId ? 'Actualizado' : 'Creado', 'success');
      setShowForm(false);
      load();
    } catch (e) {
      show((e as Error).message, 'error');
    }
  };

  return (
    <div className="page">
      <div className="card">
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <h2>Catálogo Global</h2>
            <p style={{ color: 'var(--muted)', margin: 0 }}>Productos y servicios publicados en Crefigex Live.</p>
          </div>
          <div style={{ display: 'flex', gap: 10 }}>
            <button className="btn secondary" onClick={load} disabled={loading}>{loading ? 'Cargando...' : 'Refrescar'}</button>
            <button className="btn secondary" onClick={() => openForm(false)}>Nuevo producto</button>
            <button className="btn secondary" onClick={() => openForm(true)}>Nuevo servicio</button>
            <button className="btn secondary" onClick={exportCsv} disabled={!items.length}>Exportar</button>
          </div>
        </div>
        {error && <p style={{ color: '#fca5a5' }}>{error}</p>}
        <table style={{ marginTop: 12 }}>
          <thead>
            <tr>
              <th>Nombre</th>
              <th>Vendedor</th>
              <th>Categoría</th>
              <th>Tipo</th>
              <th>Estado</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {items.map(item => (
              <tr key={item.id}>
                <td>{item.name}</td>
                <td>{item.vendor_id || '-'}</td>
                <td>{item.category_id || '-'}</td>
                <td>{item.type}</td>
                <td>
                  <span className={(item.active ?? true) ? 'badge approved' : 'badge pending'}>
                    {(item.active ?? true) ? 'ACTIVO' : 'INACTIVO'}
                  </span>
                </td>
                <td style={{ display: 'flex', gap: 6 }}>
                  <button className="btn secondary" onClick={() => openForm(item.type === 'SERVICIO', item)}>Editar</button>
                  <button
                    className="btn danger"
                    onClick={async () => {
                      if (!token) return;
                      try {
                        if (item.type === 'PRODUCTO') await catalogApi.deleteProduct(token, item.id);
                        else await catalogApi.deleteService(token, item.id);
                        show('Eliminado', 'success');
                        load();
                      } catch (e) {
                        show((e as Error).message, 'error');
                      }
                    }}
                  >
                    Borrar
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <Toast />
    </div>
    {showForm && (
      <div className="modal">
        <div className="modal-content card" style={{ width: 420 }}>
          <h3 style={{ marginTop: 0 }}>{editingId ? 'Editar' : 'Crear'} {isService ? 'servicio' : 'producto'}</h3>
          <div className="form">
            <div className="field">
              <label>Vendor ID</label>
              <input value={form.vendor_id} onChange={e => setForm({ ...form, vendor_id: e.target.value })} required />
            </div>
            <div className="field">
              <label>Nombre</label>
              <input value={form.name} onChange={e => setForm({ ...form, name: e.target.value })} required />
            </div>
            <div className="field">
              <label>Precio</label>
              <input type="number" value={form.price} onChange={e => setForm({ ...form, price: Number(e.target.value) })} required />
            </div>
            {!isService && (
              <div className="field">
                <label>Categoría</label>
                <input value={form.category_id} onChange={e => setForm({ ...form, category_id: e.target.value })} />
              </div>
            )}
            {isService && (
              <div className="field">
                <label>Tipo de servicio</label>
                <input value={form.service_type} onChange={e => setForm({ ...form, service_type: e.target.value })} />
              </div>
            )}
          </div>
          <div style={{ display: 'flex', gap: 8, marginTop: 12 }}>
            <button className="btn" onClick={submitForm}>Guardar</button>
            <button className="btn secondary" onClick={() => setShowForm(false)}>Cancelar</button>
          </div>
        </div>
      </div>
    )}
    <Toast />
  );
};

export default GlobalCatalog;
