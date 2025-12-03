import { useAuth } from '../context/AuthContext';
import { API_BASE_URL, authHeaders } from '../api/config';
import { authApi } from '../api/auth';

export const useApi = () => {
  const { token, logout, setToken } = useAuth();

  const request = async (path: string, options: RequestInit = {}, retry = false): Promise<Response> => {
    const res = await fetch(`${API_BASE_URL}${path}`, {
      ...options,
      headers: {
        ...(options.headers || {}),
        ...authHeaders(token || undefined),
      },
    });
    if (res.status === 401 && !retry && token) {
      try {
        const refreshed = await authApi.refresh(token);
        if (refreshed?.token) {
          setToken(refreshed.token);
          return request(path, options, true);
        }
      } catch {
        // ignore
      }
      logout();
      throw new Error('Sesión expirada');
    }
    return res;
  };

  return { request };
};
