import { API_BASE_URL, authHeaders } from './config';

export type Category = { id: string; name: string };
export type ProductType = { id: string; name: string };
export type ServiceType = { id: string; name: string };
export type CatalogItem = { id: string; name: string; vendor_id?: string; category_id?: string; active?: boolean };

const headers = (token?: string) => authHeaders(token);

export const catalogApi = {
  listCategories: async (token: string): Promise<Category[]> => {
    const res = await fetch(`${API_BASE_URL}/admin/categories`, { headers: headers(token) });
    if (!res.ok) throw new Error('Error al listar categorías');
    return res.json();
  },
  createCategory: async (token: string, name: string) => {
    const res = await fetch(`${API_BASE_URL}/admin/categories`, {
      method: 'POST',
      headers: headers(token),
      body: JSON.stringify({ name }),
    });
    if (!res.ok) throw new Error('Error al crear categoría');
    return res.json();
  },
  updateCategory: async (token: string, id: string, name: string) => {
    const res = await fetch(`${API_BASE_URL}/admin/categories/${id}`, {
      method: 'PUT',
      headers: headers(token),
      body: JSON.stringify({ name }),
    });
    if (!res.ok) throw new Error('Error al actualizar categoría');
    return true;
  },
  deleteCategory: async (token: string, id: string) => {
    const res = await fetch(`${API_BASE_URL}/admin/categories/${id}`, { method: 'DELETE', headers: headers(token) });
    if (!res.ok) throw new Error('Error al eliminar categoría');
    return true;
  },
  listProductTypes: async (token: string): Promise<ProductType[]> => {
    const res = await fetch(`${API_BASE_URL}/admin/product-types`, { headers: headers(token) });
    if (!res.ok) throw new Error('Error al listar tipos');
    return res.json();
  },
  createProductType: async (token: string, name: string) => {
    const res = await fetch(`${API_BASE_URL}/admin/product-types`, {
      method: 'POST',
      headers: headers(token),
      body: JSON.stringify({ name }),
    });
    if (!res.ok) throw new Error('Error al crear tipo');
    return res.json();
  },
  updateProductType: async (token: string, id: string, name: string) => {
    const res = await fetch(`${API_BASE_URL}/admin/product-types/${id}`, {
      method: 'PUT',
      headers: headers(token),
      body: JSON.stringify({ name }),
    });
    if (!res.ok) throw new Error('Error al actualizar tipo');
    return true;
  },
  deleteProductType: async (token: string, id: string) => {
    const res = await fetch(`${API_BASE_URL}/admin/product-types/${id}`, { method: 'DELETE', headers: headers(token) });
    if (!res.ok) throw new Error('Error al eliminar tipo');
    return true;
  },
  listServiceTypes: async (token: string): Promise<ServiceType[]> => {
    const res = await fetch(`${API_BASE_URL}/admin/service-types`, { headers: headers(token) });
    if (!res.ok) throw new Error('Error al listar tipos de servicio');
    return res.json();
  },
  createServiceType: async (token: string, name: string) => {
    const res = await fetch(`${API_BASE_URL}/admin/service-types`, {
      method: 'POST',
      headers: headers(token),
      body: JSON.stringify({ name }),
    });
    if (!res.ok) throw new Error('Error al crear tipo de servicio');
    return res.json();
  },
  updateServiceType: async (token: string, id: string, name: string) => {
    const res = await fetch(`${API_BASE_URL}/admin/service-types/${id}`, {
      method: 'PUT',
      headers: headers(token),
      body: JSON.stringify({ name }),
    });
    if (!res.ok) throw new Error('Error al actualizar tipo de servicio');
    return true;
  },
  deleteServiceType: async (token: string, id: string) => {
    const res = await fetch(`${API_BASE_URL}/admin/service-types/${id}`, { method: 'DELETE', headers: headers(token) });
    if (!res.ok) throw new Error('Error al eliminar tipo de servicio');
    return true;
  },
  deleteProduct: async (token: string, id: string) => {
    const res = await fetch(`${API_BASE_URL}/admin/catalog/products/${id}`, { method: 'DELETE', headers: headers(token) });
    if (!res.ok) throw new Error('Error al eliminar producto');
    return true;
  },
  deleteService: async (token: string, id: string) => {
    const res = await fetch(`${API_BASE_URL}/admin/catalog/services/${id}`, { method: 'DELETE', headers: headers(token) });
    if (!res.ok) throw new Error('Error al eliminar servicio');
    return true;
  },
};
