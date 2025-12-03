import React, { createContext, useContext, useEffect, useState } from 'react';
import { authApi } from '../api/auth';

type AuthState = {
  token: string | null;
  loading: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
  setToken: (t: string | null) => void;
};

const AuthContext = createContext<AuthState | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [token, setToken] = useState<string | null>(() => localStorage.getItem('admin_token'));
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (token) localStorage.setItem('admin_token', token);
    else localStorage.removeItem('admin_token');
  }, [token]);

  const login = async (email: string, password: string) => {
    setLoading(true);
    try {
      const res = await authApi.login(email, password);
      setToken(res.token);
      localStorage.setItem('admin_token', res.token);
    } finally {
      setLoading(false);
    }
  };

  const logout = () => {
    setToken(null);
    localStorage.removeItem('admin_token');
  };

  const setTokenValue = (t: string | null) => {
    setToken(t);
  };

  return (
    <AuthContext.Provider value={{ token, loading, login, logout, setToken: setTokenValue }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used within AuthProvider');
  return ctx;
};
