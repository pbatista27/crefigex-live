import { API_BASE_URL, authHeaders } from './config';

export type LoginResponse = { token: string };

export const authApi = {
  login: async (email: string, password: string): Promise<LoginResponse> => {
    const res = await fetch(`${API_BASE_URL}/auth/login`, {
      method: 'POST',
      headers: authHeaders(),
      body: JSON.stringify({ email, password }),
    });
    if (!res.ok) {
      throw new Error('Credenciales inválidas');
    }
    return res.json();
  },
  me: async (token: string) => {
    const res = await fetch(`${API_BASE_URL}/me`, {
      headers: authHeaders(token),
    });
    if (!res.ok) throw new Error('Sesión expirada');
    return res.json();
  },
  refresh: async (token: string) => {
    const res = await fetch(`${API_BASE_URL}/auth/refresh`, {
      method: 'POST',
      headers: authHeaders(token),
    });
    if (!res.ok) throw new Error('No se pudo refrescar sesión');
    return res.json();
  },
};
