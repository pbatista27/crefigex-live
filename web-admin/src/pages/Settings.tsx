import { useEffect, useState } from 'react';
import { catalogApi, Category, ProductType, ServiceType } from '../api/catalog';
import { useAuth } from '../context/AuthContext';
import { useToast } from '../hooks/useToast';

const Settings = () => {
  const [categories, setCategories] = useState<Category[]>([]);
  const [types, setTypes] = useState<ProductType[]>([]);
  const [catName, setCatName] = useState('');
  const [typeName, setTypeName] = useState('');
  const [serviceName, setServiceName] = useState('');
  const [editCat, setEditCat] = useState<Category | null>(null);
  const [editType, setEditType] = useState<ProductType | null>(null);
  const [serviceTypes, setServiceTypes] = useState<ServiceType[]>([]);
  const [editService, setEditService] = useState<ServiceType | null>(null);
  const { token } = useAuth();
  const { show, Toast } = useToast();
  const [errors, setErrors] = useState<string>('');

  const loadData = async () => {
    if (!token) return;
    try {
      setErrors('');
      setCategories(await catalogApi.listCategories(token));
      setTypes(await catalogApi.listProductTypes(token));
      setServiceTypes(await catalogApi.listServiceTypes(token));
    } catch (e) {
      setErrors((e as Error).message);
      show('Error cargando catálogos', 'error');
    }
  };

  useEffect(() => {
    loadData();
  }, []);

  const saveCategory = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!token) return;
    try {
      if (editCat) {
        await catalogApi.updateCategory(token, editCat.id, catName);
        show('Categoría actualizada', 'success');
      } else {
        await catalogApi.createCategory(token, catName);
        show('Categoría creada', 'success');
      }
      setCatName('');
      setEditCat(null);
      loadData();
    } catch (e) {
      show((e as Error).message, 'error');
    }
  };

  const saveType = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!token) return;
    try {
      if (editType) {
        await catalogApi.updateProductType(token, editType.id, typeName);
        show('Tipo actualizado', 'success');
      } else {
        await catalogApi.createProductType(token, typeName);
        show('Tipo creado', 'success');
      }
      setTypeName('');
      setEditType(null);
      loadData();
    } catch (e) {
      show((e as Error).message, 'error');
    }
  };

  const saveServiceType = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!token) return;
    try {
      if (editService) {
        await catalogApi.updateServiceType(token, editService.id, serviceName);
        show('Tipo de servicio actualizado', 'success');
      } else {
        await catalogApi.createServiceType(token, serviceName);
        show('Tipo de servicio creado', 'success');
      }
      setServiceName('');
      setEditService(null);
      loadData();
    } catch (e) {
      show((e as Error).message, 'error');
    }
  };

  return (
    <div className="page">
      <div className="card">
        <h2>Catálogos</h2>
        <p style={{ color: 'var(--muted)', marginTop: 4 }}>CRUD de categorías y tipos de producto/servicio.</p>
        {errors && <p style={{ color: '#fca5a5' }}>{errors}</p>}
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
                      <button className="btn danger" onClick={async () => { if (!token) return; await catalogApi.deleteCategory(token, c.id); loadData(); }}>
                        Eliminar
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <div className="card">
            <h3 style={{ marginTop: 0 }}>Tipos de producto</h3>
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
                      <button className="btn danger" onClick={async () => { if (!token) return; await catalogApi.deleteProductType(token, t.id); loadData(); }}>
                        Eliminar
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        <div className="card">
          <h3 style={{ marginTop: 0 }}>Tipos de servicio</h3>
          <form onSubmit={saveServiceType} className="form" style={{ marginBottom: 12 }}>
            <div className="field">
              <label>{editService ? 'Editar tipo' : 'Nuevo tipo'}</label>
              <input
                value={serviceName}
                onChange={e => setServiceName(e.target.value)}
                placeholder="Ej: Barbería, Reparaciones, Salud"
                required
              />
            </div>
            <div style={{ display: 'flex', gap: 8 }}>
              <button className="btn" type="submit">{editService ? 'Guardar cambios' : 'Agregar'}</button>
              {editService && (
                <button className="btn secondary" type="button" onClick={() => { setEditService(null); setServiceName(''); }}>
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
              {serviceTypes.map(s => (
                <tr key={s.id}>
                  <td>{s.name}</td>
                  <td style={{ display: 'flex', gap: 6 }}>
                    <button className="btn secondary" onClick={() => { setEditService(s); setServiceName(s.name); }}>
                      Editar
                    </button>
                    <button className="btn danger" onClick={async () => { if (!token) return; await catalogApi.deleteServiceType(token, s.id); loadData(); }}>
                      Eliminar
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
      <Toast />
    </div>
  );
};

export default Settings;
