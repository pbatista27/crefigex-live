import { API_BASE_URL, authHeaders } from './config';

export type AdminOrder = {
  id: string;
  customer_name: string;
  vendor_name: string;
  status: string;
  payment_plan: string;
  total_amount: number;
  created_at?: string;
};

export const ordersApi = {
  listAdmin: async (token: string): Promise<AdminOrder[]> => {
    const res = await fetch(`${API_BASE_URL}/admin/orders`, { headers: authHeaders(token) });
    if (!res.ok) throw new Error('Error al listar órdenes');
    const data = await res.json();
    return data.data || [];
  },
};
