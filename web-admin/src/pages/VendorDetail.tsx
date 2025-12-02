import { useParams } from 'react-router-dom';

const VendorDetail = () => {
  const { id } = useParams();
  return (
    <div className="page">
      <div className="card">
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <div className="pill">Vendedor #{id}</div>
            <h2 style={{ margin: '6px 0' }}>Comercio Uno</h2>
            <p style={{ color: 'var(--muted)', margin: 0 }}>Catálogo + Live commerce. RIF J-123456.</p>
          </div>
          <span className="badge pending">PENDING</span>
        </div>
        <div style={{ display: 'grid', gap: 10, marginTop: 18 }}>
          <div className="field">
            <label>Contacto</label>
            <div>ventas@comercio.com · +58 412 0000000</div>
          </div>
          <div className="field">
            <label>Dirección</label>
            <div>Av. Principal, Caracas</div>
          </div>
          <div className="field">
            <label>Categoría</label>
            <div>Electrónica · Productos físicos</div>
          </div>
        </div>
        <div style={{ display: 'flex', gap: 10, marginTop: 18 }}>
          <button className="btn">Aprobar</button>
          <button className="btn secondary">Rechazar</button>
          <button className="btn danger">Suspender</button>
        </div>
      </div>
    </div>
  );
};

export default VendorDetail;
