import { API_BASE_URL, authHeaders } from './config';

export type Vendor = {
  id: string;
  name: string;
  email?: string;
  phone?: string;
  vendor_type?: string;
  status: string;
};

export const vendorApi = {
  list: async (token: string, status?: string): Promise<Vendor[]> => {
    const res = await fetch(`${API_BASE_URL}/admin/vendors${status ? `?status=${status}` : ''}`, {
      headers: authHeaders(token),
    });
    if (!res.ok) throw new Error('Error al listar vendedores');
    const data = await res.json();
    return data.data || [];
  },
  approve: async (token: string, id: string) => {
    const res = await fetch(`${API_BASE_URL}/admin/vendors/${id}/approve`, {
      method: 'POST',
      headers: authHeaders(token),
    });
    if (!res.ok) throw new Error('Error al aprobar');
    return true;
  },
  reject: async (token: string, id: string) => {
    const res = await fetch(`${API_BASE_URL}/admin/vendors/${id}/reject`, {
      method: 'POST',
      headers: authHeaders(token),
    });
    if (!res.ok) throw new Error('Error al rechazar');
    return true;
  },
  suspend: async (token: string, id: string) => {
    const res = await fetch(`${API_BASE_URL}/admin/vendors/${id}/suspend`, {
      method: 'POST',
      headers: authHeaders(token),
    });
    if (!res.ok) throw new Error('Error al suspender');
    return true;
  },
  get: async (token: string, id: string): Promise<Vendor> => {
    const res = await fetch(`${API_BASE_URL}/vendors/${id}`, {
      headers: authHeaders(token),
    });
    if (!res.ok) throw new Error('No se pudo obtener el vendedor');
    const data = await res.json();
    return data.vendor || data;
  },
};
