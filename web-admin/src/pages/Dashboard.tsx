const Dashboard = () => {
  return (
    <div className="page">
      <div className="grid cols-3">
        <div className="card stat">
          <div className="label">Ventas del día</div>
          <div className="value">$12,430</div>
          <div className="pill">+12% vs ayer</div>
        </div>
        <div className="card stat">
          <div className="label">Pagos pendientes</div>
          <div className="value">37 cuotas</div>
          <div className="pill">Morosidad controlada</div>
        </div>
        <div className="card stat">
          <div className="label">Solicitudes de vendedores</div>
          <div className="value">8 nuevas</div>
          <button className="btn secondary" style={{ width: 'fit-content' }}>Revisar</button>
        </div>
      </div>

      <div className="card">
        <h2>Ventas y BNPL</h2>
        <p style={{ color: 'var(--muted)', marginTop: 6 }}>Seguimiento de cuotas y flujo de caja por plan.</p>
        <div className="grid cols-3" style={{ marginTop: 12 }}>
          <div>
            <div className="label">Plan 7 días</div>
            <div className="value">18 órdenes</div>
            <div className="pill">Tasa de aprobación 92%</div>
          </div>
          <div>
            <div className="label">Plan 15 días</div>
            <div className="value">24 órdenes</div>
            <div className="pill">Ticket promedio $86</div>
          </div>
          <div>
            <div className="label">Morosidad</div>
            <div className="value">3.1%</div>
            <div className="pill">Objetivo &lt; 5%</div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
