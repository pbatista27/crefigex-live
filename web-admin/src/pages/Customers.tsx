const Customers = () => {
  const customers = [
    { name: 'María Pérez', plan: '15 días', status: 'ACTIVA', risk: 'Bajo' },
    { name: 'Luis Gómez', plan: '7 días', status: 'ACTIVA', risk: 'Medio' },
  ];

  return (
    <div className="page">
      <div className="card">
        <h2>Clientes</h2>
        <p style={{ color: 'var(--muted)', marginTop: 4 }}>Seguimiento de usuarios BNPL y su nivel de riesgo.</p>
        <table style={{ marginTop: 12 }}>
          <thead>
            <tr>
              <th>Nombre</th>
              <th>Plan BNPL</th>
              <th>Estado</th>
              <th>Riesgo</th>
            </tr>
          </thead>
          <tbody>
            {customers.map(c => (
              <tr key={c.name}>
                <td>{c.name}</td>
                <td>{c.plan}</td>
                <td><span className="badge approved">ACTIVA</span></td>
                <td>{c.risk}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default Customers;
