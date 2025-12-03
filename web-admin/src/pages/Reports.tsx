import React, { useEffect, useState } from 'react';
import { useToast } from '../hooks/useToast';
import { reportingApi, SummaryReport } from '../api/reporting';
import { useAuth } from '../context/AuthContext';

const reports = [
  { id: 'r1', name: 'Ventas por categoría', desc: 'Segmento productos/servicios', action: 'Descargar CSV' },
  { id: 'r2', name: 'Pagos BNPL', desc: 'Cuotas pendientes vs pagadas', action: 'Programar envío' },
  { id: 'r3', name: 'Rendimiento de vendedores', desc: 'Top 20 por conversión', action: 'Ver en dashboard' },
];

const Reports: React.FC = () => {
  const { show, Toast } = useToast();
  const { token } = useAuth();
  const [loadingId, setLoadingId] = useState<string | null>(null);
  const [summary, setSummary] = useState<SummaryReport | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    const load = async () => {
      if (!token) return;
      setLoading(true);
      try {
        setError('');
        const data = await reportingApi.summary(token);
        setSummary(data);
      } catch (e) {
        setError((e as Error).message);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, [token]);

  const download = async (id: string) => {
    setLoadingId(id);
    // Simula descarga; aquí se llamaría a /admin/reporting/{id}
    setTimeout(() => {
      show('Reporte generado (mock)', 'success');
      setLoadingId(null);
    }, 800);
  };

  return (
    <div className="page">
      <div className="grid cols-3">
        {loading && <div className="card stat">Cargando...</div>}
        {!loading && summary && (
          <>
            <div className="card stat">
              <span className="label">GMV Últimos 7 días</span>
              <span className="value">${summary.gmv_7d.toLocaleString()}</span>
            </div>
            <div className="card stat">
              <span className="label">Órdenes BNPL</span>
              <span className="value">{summary.orders_bnpl}</span>
            </div>
            <div className="card stat">
              <span className="label">Ticket Promedio</span>
              <span className="value">${summary.avg_ticket}</span>
            </div>
            <div className="card stat">
              <span className="label">Entregas Completas</span>
              <span className="value">{summary.deliveries_complete}</span>
            </div>
          </>
        )}
      </div>

      <div className="card">
        <h2>Reportes</h2>
        <p style={{ color: 'var(--muted)', marginTop: 4 }}>Plantillas frecuentes para analítica y conciliación.</p>
        {error && <p style={{ color: '#fca5a5' }}>{error}</p>}
        <table style={{ marginTop: 12 }}>
          <thead>
            <tr>
              <th>Nombre</th>
              <th>Descripción</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {reports.map(r => (
              <tr key={r.id}>
                <td>{r.name}</td>
                <td style={{ color: 'var(--muted)' }}>{r.desc}</td>
                <td style={{ textAlign: 'right' }}>
                  <button className="btn secondary" onClick={() => download(r.id)} disabled={loadingId === r.id}>
                    {loadingId === r.id ? 'Generando...' : r.action}
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

export default Reports;
