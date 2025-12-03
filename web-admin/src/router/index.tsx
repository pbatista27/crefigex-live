import { Routes, Route, Navigate, NavLink } from 'react-router-dom';
import LoginPage from '../pages/LoginPage';
import Dashboard from '../pages/Dashboard';
import Vendors from '../pages/Vendors';
import VendorDetail from '../pages/VendorDetail';
import Customers from '../pages/Customers';
import Orders from '../pages/Orders';
import Deliveries from '../pages/Deliveries';
import CrefigexDeliveries from '../pages/CrefigexDeliveries';
import GlobalCatalog from '../pages/GlobalCatalog';
import Reports from '../pages/Reports';
import Settings from '../pages/Settings';
import { Protected } from '../hooks/useAuthGuard';

const navItems = [
  { to: '/dashboard', label: 'Dashboard', icon: '🏠' },
  { to: '/vendors', label: 'Vendedores', icon: '🛒' },
  { to: '/customers', label: 'Clientes', icon: '👥' },
  { to: '/catalog', label: 'Catálogo global', icon: '📦' },
  { to: '/orders', label: 'Ventas', icon: '📊' },
  { to: '/deliveries', label: 'Entregas internas', icon: '🚚' },
  { to: '/crefigex-deliveries', label: 'Entregas Crefigex', icon: '🛰️' },
  { to: '/reports', label: 'Reportes', icon: '📈' },
  { to: '/settings', label: 'Catálogos', icon: '⚙️' },
];

const Sidebar = () => (
  <div className="sidebar">
    <h3>Crefigex Admin</h3>
    <ul className="nav-links">
      {navItems.map(item => (
        <li key={item.to}>
          <NavLink to={item.to} className={({ isActive }) => `nav-link ${isActive ? 'active' : ''}`}>
            <span>{item.icon}</span>
            <span>{item.label}</span>
          </NavLink>
        </li>
      ))}
    </ul>
  </div>
);

const AppRouter = () => (
  <Routes>
    <Route path="/login" element={<LoginPage />} />
    <Route
      path="/*"
      element={
        <Protected>
          <div className="app-shell">
            <Sidebar />
            <div className="content">
              <div className="topbar">
                <div>
                  <div className="pill">Panel Crefigex Live</div>
                  <h1>Control Center</h1>
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
                  <div className="pill">Versión 0.1 · Live Commerce BNPL</div>
                  <button className="btn secondary" onClick={() => window.location.href = '/login'}>
                    Salir
                  </button>
                </div>
              </div>
              <Routes>
                <Route path="/dashboard" element={<Dashboard />} />
                <Route path="/vendors" element={<Vendors />} />
                <Route path="/vendors/:id" element={<VendorDetail />} />
                <Route path="/customers" element={<Customers />} />
                <Route path="/orders" element={<Orders />} />
                <Route path="/deliveries" element={<Deliveries />} />
                <Route path="/crefigex-deliveries" element={<CrefigexDeliveries />} />
                <Route path="/catalog" element={<GlobalCatalog />} />
                <Route path="/reports" element={<Reports />} />
                <Route path="/settings" element={<Settings />} />
                <Route path="*" element={<Navigate to="/dashboard" />} />
              </Routes>
            </div>
          </div>
        </Protected>
      }
    />
  </Routes>
);

export default AppRouter;
