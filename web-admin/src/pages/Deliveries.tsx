const Deliveries = () => {
  const deliveries = [
    { id: 'D-1', type: 'CREFIGEX', status: 'IN_DELIVERY' },
    { id: 'D-2', type: 'INTERNAL', status: 'DELIVERED' },
  ];

  const badge = (status: string) => {
    const normalized = status === 'DELIVERED' ? 'approved' : 'pending';
    return <span className={`badge ${normalized}`}>{status}</span>;
  };

  return (
    <div className="page">
      <div className="card">
        <h2>Entregas Crefigex</h2>
        <p style={{ color: 'var(--muted)', marginTop: 4 }}>Estados logísticos sincronizados con entregadores.</p>
        <table style={{ marginTop: 12 }}>
          <thead>
            <tr>
              <th>ID</th>
              <th>Tipo</th>
              <th>Estado</th>
            </tr>
          </thead>
          <tbody>
            {deliveries.map(d => (
              <tr key={d.id}>
                <td>{d.id}</td>
                <td>{d.type}</td>
                <td>{badge(d.status)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default Deliveries;
