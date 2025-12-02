export type Category = { id: string; name: string };
export type ProductType = { id: string; name: string };

// Mock data in-memory for now
let categories: Category[] = [
  { id: 'c1', name: 'Electrónica' },
  { id: 'c2', name: 'Moda' },
];

let productTypes: ProductType[] = [
  { id: 't1', name: 'Smartphones' },
  { id: 't2', name: 'Accesorios' },
  { id: 't3', name: 'Servicios Técnicos' },
];

export const catalogApi = {
  listCategories: async (): Promise<Category[]> => {
    return Promise.resolve(categories);
  },
  createCategory: async (name: string) => {
    const newItem = { id: `c${Date.now()}`, name };
    categories = [...categories, newItem];
    return Promise.resolve(newItem);
  },
  updateCategory: async (id: string, name: string) => {
    categories = categories.map(c => (c.id === id ? { ...c, name } : c));
    return Promise.resolve(true);
  },
  deleteCategory: async (id: string) => {
    categories = categories.filter(c => c.id !== id);
    return Promise.resolve(true);
  },
  listProductTypes: async (): Promise<ProductType[]> => {
    return Promise.resolve(productTypes);
  },
  createProductType: async (name: string) => {
    const newItem = { id: `t${Date.now()}`, name };
    productTypes = [...productTypes, newItem];
    return Promise.resolve(newItem);
  },
  updateProductType: async (id: string, name: string) => {
    productTypes = productTypes.map(t => (t.id === id ? { ...t, name } : t));
    return Promise.resolve(true);
  },
  deleteProductType: async (id: string) => {
    productTypes = productTypes.filter(t => t.id !== id);
    return Promise.resolve(true);
  },
};
