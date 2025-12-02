const Orders = () => {
  const orders = [
    { id: '#1001', customer: 'María', vendor: 'Comercio Uno', status: 'APROBADA', plan: '15d' },
    { id: '#1002', customer: 'Luis', vendor: 'Prestador Dos', status: 'PENDIENTE', plan: '7d' },
  ];

  const badge = (status: string) => {
    const cls =
      status === 'APROBADA' ? 'badge approved' : status === 'PENDIENTE' ? 'badge pending' : 'badge rejected';
    return <span className={cls}>{status}</span>;
  };

  return (
    <div className="page">
      <div className="card">
        <h2>Ventas BNPL</h2>
        <p style={{ color: 'var(--muted)', marginTop: 4 }}>Órdenes, planes de pago y estados de aprobación.</p>
        <table style={{ marginTop: 12 }}>
          <thead>
            <tr>
              <th>ID</th>
              <th>Cliente</th>
              <th>Vendedor</th>
              <th>Plan</th>
              <th>Estado</th>
            </tr>
          </thead>
          <tbody>
            {orders.map(o => (
              <tr key={o.id}>
                <td>{o.id}</td>
                <td>{o.customer}</td>
                <td>{o.vendor}</td>
                <td>{o.plan}</td>
                <td>{badge(o.status)}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default Orders;
