import { useEffect, useState } from 'react';
import { catalogApi, Category, ProductType } from '../api/catalog';

const Settings = () => {
  const [categories, setCategories] = useState<Category[]>([]);
  const [types, setTypes] = useState<ProductType[]>([]);
  const [catName, setCatName] = useState('');
  const [typeName, setTypeName] = useState('');
  const [editCat, setEditCat] = useState<Category | null>(null);
  const [editType, setEditType] = useState<ProductType | null>(null);

  const loadData = async () => {
    setCategories(await catalogApi.listCategories());
    setTypes(await catalogApi.listProductTypes());
  };

  useEffect(() => {
    loadData();
  }, []);

  const saveCategory = async (e: React.FormEvent) => {
    e.preventDefault();
    if (editCat) {
      await catalogApi.updateCategory(editCat.id, catName);
    } else {
      await catalogApi.createCategory(catName);
    }
    setCatName('');
    setEditCat(null);
    loadData();
  };

  const saveType = async (e: React.FormEvent) => {
    e.preventDefault();
    if (editType) {
      await catalogApi.updateProductType(editType.id, typeName);
    } else {
      await catalogApi.createProductType(typeName);
    }
    setTypeName('');
    setEditType(null);
    loadData();
  };

  return (
    <div className="page">
      <div className="card">
        <h2>Catálogos</h2>
        <p style={{ color: 'var(--muted)', marginTop: 4 }}>CRUD de categorías y tipos de producto/servicio.</p>
        <div className="grid" style={{ gridTemplateColumns: '1fr 1fr' }}>
          <div className="card">
            <h3 style={{ marginTop: 0 }}>Categorías</h3>
            <form onSubmit={saveCategory} className="form" style={{ marginBottom: 12 }}>
              <div className="field">
                <label>{editCat ? 'Editar categoría' : 'Nueva categoría'}</label>
                <input
                  value={catName}
                  onChange={e => setCatName(e.target.value)}
                  placeholder="Ej: Electrónica"
                  required
                />
              </div>
              <div style={{ display: 'flex', gap: 8 }}>
                <button className="btn" type="submit">{editCat ? 'Guardar cambios' : 'Agregar'}</button>
                {editCat && (
                  <button className="btn secondary" type="button" onClick={() => { setEditCat(null); setCatName(''); }}>
                    Cancelar
                  </button>
                )}
              </div>
            </form>
            <table>
              <thead>
                <tr>
                  <th>Nombre</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {categories.map(c => (
                  <tr key={c.id}>
                    <td>{c.name}</td>
                    <td style={{ display: 'flex', gap: 6 }}>
                      <button className="btn secondary" onClick={() => { setEditCat(c); setCatName(c.name); }}>
                        Editar
                      </button>
                      <button className="btn danger" onClick={async () => { await catalogApi.deleteCategory(c.id); loadData(); }}>
                        Eliminar
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <div className="card">
            <h3 style={{ marginTop: 0 }}>Tipos de producto / servicio</h3>
            <form onSubmit={saveType} className="form" style={{ marginBottom: 12 }}>
              <div className="field">
                <label>{editType ? 'Editar tipo' : 'Nuevo tipo'}</label>
                <input
                  value={typeName}
                  onChange={e => setTypeName(e.target.value)}
                  placeholder="Ej: Smartphones, Barbería"
                  required
                />
              </div>
              <div style={{ display: 'flex', gap: 8 }}>
                <button className="btn" type="submit">{editType ? 'Guardar cambios' : 'Agregar'}</button>
                {editType && (
                  <button className="btn secondary" type="button" onClick={() => { setEditType(null); setTypeName(''); }}>
                    Cancelar
                  </button>
                )}
              </div>
            </form>
            <table>
              <thead>
                <tr>
                  <th>Nombre</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                {types.map(t => (
                  <tr key={t.id}>
                    <td>{t.name}</td>
                    <td style={{ display: 'flex', gap: 6 }}>
                      <button className="btn secondary" onClick={() => { setEditType(t); setTypeName(t.name); }}>
                        Editar
                      </button>
                      <button className="btn danger" onClick={async () => { await catalogApi.deleteProductType(t.id); loadData(); }}>
                        Eliminar
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Settings;
