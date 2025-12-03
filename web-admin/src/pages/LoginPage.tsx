import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

const LoginPage = () => {
  const navigate = useNavigate();
  const { login, loading } = useAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      setError('');
      await login(email, password);
      navigate('/dashboard');
    } catch (err) {
      setError((err as Error).message);
    }
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
            <input type="email" required placeholder="admin@crefigex.com" value={email} onChange={e => setEmail(e.target.value)} />
          </div>
          <div className="field">
            <label>Contraseña</label>
            <input type="password" required placeholder="••••••••" value={password} onChange={e => setPassword(e.target.value)} />
          </div>
          <button type="submit" className="btn" style={{ width: '100%' }} disabled={loading}>
            {loading ? 'Ingresando...' : 'Ingresar'}
          </button>
          {error && <p style={{ color: '#fca5a5', marginTop: 12 }}>{error}</p>}
        </form>
      </div>
    </div>
  );
};

export default LoginPage;
