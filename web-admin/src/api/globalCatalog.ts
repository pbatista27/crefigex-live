import { API_BASE_URL, authHeaders } from './config';

export type GlobalProduct = {
  id?: string;
  vendor_id: string;
  name: string;
  description?: string;
  price: number;
  currency?: string;
  category_id?: string;
  active?: boolean;
};

export type GlobalService = {
  id?: string;
  vendor_id: string;
  name: string;
  description?: string;
  price: number;
  currency?: string;
  service_type?: string;
  active?: boolean;
};

const headers = (token: string) => authHeaders(token);

export const globalCatalogApi = {
  createProduct: async (token: string, payload: GlobalProduct) => {
    const res = await fetch(`${API_BASE_URL}/admin/catalog/products`, {
      method: 'POST',
      headers: headers(token),
      body: JSON.stringify(payload),
    });
    if (!res.ok) throw new Error('Error al crear producto');
    return res.json();
  },
  updateProduct: async (token: string, id: string, payload: GlobalProduct) => {
    const res = await fetch(`${API_BASE_URL}/admin/catalog/products/${id}`, {
      method: 'PUT',
      headers: headers(token),
      body: JSON.stringify(payload),
    });
    if (!res.ok) throw new Error('Error al actualizar producto');
    return res.json();
  },
  createService: async (token: string, payload: GlobalService) => {
    const res = await fetch(`${API_BASE_URL}/admin/catalog/services`, {
      method: 'POST',
      headers: headers(token),
      body: JSON.stringify(payload),
    });
    if (!res.ok) throw new Error('Error al crear servicio');
    return res.json();
  },
  updateService: async (token: string, id: string, payload: GlobalService) => {
    const res = await fetch(`${API_BASE_URL}/admin/catalog/services/${id}`, {
      method: 'PUT',
      headers: headers(token),
      body: JSON.stringify(payload),
    });
    if (!res.ok) throw new Error('Error al actualizar servicio');
    return res.json();
  },
};

