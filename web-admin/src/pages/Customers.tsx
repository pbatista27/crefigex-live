import { useEffect, useState } from 'react';
import { customersApi, Customer } from '../api/customers';
import { useAuth } from '../context/AuthContext';
import { catalogApi, Category } from '../api/catalog';

const Customers = () => {
  const { token } = useAuth();
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const load = async () => {
    if (!token) return;
    setLoading(true);
    try {
      setError('');
      const [cust, cats] = await Promise.all([
        customersApi.list(token),
        catalogApi.listCategories(),
      ]);
      setCustomers(cust);
      setCategories(cats);
    } catch (err) {
      setError((err as Error).message);
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
        <h2>Clientes</h2>
        <p style={{ color: 'var(--muted)', marginTop: 4 }}>Seguimiento de usuarios BNPL y su nivel de riesgo.</p>
        <div style={{ display: 'flex', gap: 8, alignItems: 'center', marginBottom: 10 }}>
          <button className="btn secondary" onClick={load} disabled={loading}>{loading ? 'Actualizando...' : 'Refrescar'}</button>
          {error && <span style={{ color: '#fca5a5' }}>{error}</span>}
        </div>
        <table style={{ marginTop: 12 }}>
          <thead>
            <tr>
              <th>Nombre</th>
              <th>Email</th>
              <th>Teléfono</th>
              <th>Categoría principal</th>
            </tr>
          </thead>
          <tbody>
            {customers.map(c => (
              <tr key={c.id}>
                <td>{c.name}</td>
                <td>{c.email}</td>
                <td>{c.phone || '-'}</td>
                <td>{categories[0]?.name || '-'}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default Customers;
