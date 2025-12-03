import { API_BASE_URL, authHeaders } from './config';

export type Customer = {
  id: string;
  name: string;
  email: string;
  phone?: string;
};

export const customersApi = {
  list: async (token: string): Promise<Customer[]> => {
    const res = await fetch(`${API_BASE_URL}/admin/customers`, {
      headers: authHeaders(token),
    });
    if (!res.ok) throw new Error('Error al listar clientes');
    const data = await res.json();
    return data.data || [];
  },
  update: async (token: string, id: string, payload: Partial<Customer>) => {
    const res = await fetch(`${API_BASE_URL}/admin/customers/${id}`, {
      method: 'PUT',
      headers: authHeaders(token),
      body: JSON.stringify(payload),
    });
    if (!res.ok) throw new Error('Error al actualizar cliente');
    return true;
  },
};
