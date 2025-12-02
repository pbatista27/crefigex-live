import { Link } from 'react-router-dom';

const Vendors = () => {
  const vendors = [
    { id: '1', name: 'Comercio Uno', status: 'PENDING', type: 'COMERCIO' },
    { id: '2', name: 'Prestador Dos', status: 'APPROVED', type: 'PRESTADOR' },
    { id: '3', name: 'Market Live', status: 'PENDING', type: 'COMERCIO' },
  ];

  const badge = (status: string) => {
    const cls =
      status === 'PENDING' ? 'badge pending' : status === 'APPROVED' ? 'badge approved' : 'badge rejected';
    return <span className={cls}>{status}</span>;
  };

  return (
    <div className="page">
      <div className="card">
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <div>
            <h2>Vendedores</h2>
            <p style={{ color: 'var(--muted)', margin: 0 }}>Aprueba comerciantes y prestadores de servicio.</p>
          </div>
          <button className="btn secondary">Exportar</button>
        </div>
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
                <td>{v.type}</td>
                <td>{badge(v.status)}</td>
                <td>
                  <Link to={`/vendors/${v.id}`} className="btn secondary">
                    Revisar
                  </Link>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default Vendors;
