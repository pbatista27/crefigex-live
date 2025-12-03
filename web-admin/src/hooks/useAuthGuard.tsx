import { Navigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

export const Protected: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { token } = useAuth();
  if (!token) return <Navigate to="/login" replace />;
  return <>{children}</>;
};
