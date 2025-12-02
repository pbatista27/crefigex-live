import { useNavigate } from 'react-router-dom';

const LoginPage = () => {
  const navigate = useNavigate();
  const submit = (e: React.FormEvent) => {
    e.preventDefault();
    navigate('/dashboard');
  };

  return (
    <div style={{ display: 'grid', placeItems: 'center', minHeight: '100vh' }}>
      <div className="card" style={{ width: 380 }}>
        <div className="pill" style={{ marginBottom: 12 }}>Acceso administradores</div>
        <h2 style={{ marginTop: 0 }}>Crefigex Admin</h2>
        <p style={{ color: 'var(--muted)', marginTop: 4, marginBottom: 18 }}>Controla vendedores, clientes y logística BNPL.</p>
        <form onSubmit={submit} className="form">
          <div className="field">
            <label>Email</label>
            <input type="email" required placeholder="admin@crefigex.com" />
          </div>
          <div className="field">
            <label>Contraseña</label>
            <input type="password" required placeholder="••••••••" />
          </div>
          <button type="submit" className="btn" style={{ width: '100%' }}>
            Ingresar
          </button>
        </form>
      </div>
    </div>
  );
};

export default LoginPage;
