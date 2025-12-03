import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  late TabController controller;
  final _clientForm = GlobalKey<FormState>();
  final _vendorForm = GlobalKey<FormState>();
  final _auth = AuthService();

  // Cliente
  final _cName = TextEditingController();
  final _cPhone = TextEditingController();
  final _cEmail = TextEditingController();
  final _cPass = TextEditingController();
  final _cPass2 = TextEditingController();

  // Vendedor
  final _vName = TextEditingController();
  final _vPhone = TextEditingController();
  final _vEmail = TextEditingController();
  final _vPass = TextEditingController();
  final _vAddress = TextEditingController();
  final _vDocument = TextEditingController();
  final _vCategory = TextEditingController();
  final _vDescription = TextEditingController();
  String _vendorType = 'COMERCIO';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
        bottom: TabBar(
          controller: controller,
          tabs: const [
            Tab(text: 'Cliente'),
            Tab(text: 'Vendedor'),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0e7ff), Color(0xFFf8fafc)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: TabBarView(
          controller: controller,
          children: [
            _clienteForm(),
            _vendedorForm(),
          ],
        ),
      ),
    );
  }

  Widget _clienteForm() => Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          shadowColor: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _clientForm,
              child: ListView(
                children: [
                  const Text('Registrarme como CLIENTE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _cName,
                    decoration: const InputDecoration(labelText: 'Nombre completo', prefixIcon: Icon(Icons.person_outline)),
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                  TextFormField(
                    controller: _cPhone,
                    decoration: const InputDecoration(labelText: 'Teléfono', prefixIcon: Icon(Icons.phone)),
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                  TextFormField(
                    controller: _cEmail,
                    decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline)),
                    validator: (v) => v != null && v.contains('@') ? null : 'Email inválido',
                  ),
                  TextFormField(
                    controller: _cPass,
                    decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock_outline)),
                    obscureText: true,
                    validator: (v) => v != null && v.length >= 6 ? null : 'Mínimo 6 caracteres',
                  ),
                  TextFormField(
                    controller: _cPass2,
                    decoration: const InputDecoration(labelText: 'Confirmar contraseña', prefixIcon: Icon(Icons.lock_outline)),
                    obscureText: true,
                    validator: (v) => v == _cPass.text ? null : 'No coinciden',
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366f1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _loading ? null : _submitClient,
                    child: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Crear cuenta', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _vendedorForm() => Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          shadowColor: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _vendorForm,
              child: ListView(
                children: [
                  const Text('Registrarme como VENDEDOR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _vendorType,
                    items: const [
                      DropdownMenuItem(value: 'COMERCIO', child: Text('COMERCIO')),
                      DropdownMenuItem(value: 'PRESTADOR_SERVICIO', child: Text('PRESTADOR DE SERVICIO')),
                    ],
                    onChanged: (v) => setState(() => _vendorType = v ?? 'COMERCIO'),
                    decoration: const InputDecoration(labelText: 'Tipo de vendedor'),
                  ),
                  TextFormField(
                    controller: _vName,
                    decoration: const InputDecoration(labelText: 'Nombre comercial', prefixIcon: Icon(Icons.storefront)),
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                  TextFormField(
                    controller: _vPhone,
                    decoration: const InputDecoration(labelText: 'Teléfono', prefixIcon: Icon(Icons.phone)),
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                  TextFormField(
                    controller: _vEmail,
                    decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline)),
                    validator: (v) => v != null && v.contains('@') ? null : 'Email inválido',
                  ),
                  TextFormField(
                    controller: _vPass,
                    decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock_outline)),
                    obscureText: true,
                    validator: (v) => v != null && v.length >= 6 ? null : 'Mínimo 6 caracteres',
                  ),
                  TextFormField(
                    controller: _vAddress,
                    decoration: const InputDecoration(labelText: 'Dirección', prefixIcon: Icon(Icons.location_on_outlined)),
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                  TextFormField(
                    controller: _vDocument,
                    decoration: const InputDecoration(labelText: 'Documento / RIF', prefixIcon: Icon(Icons.badge_outlined)),
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                  TextFormField(
                    controller: _vCategory,
                    decoration: const InputDecoration(labelText: 'Categoría principal', prefixIcon: Icon(Icons.category_outlined)),
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                  TextFormField(
                    controller: _vDescription,
                    decoration: const InputDecoration(labelText: 'Descripción', prefixIcon: Icon(Icons.description_outlined)),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366f1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _loading ? null : _submitVendor,
                    child: _loading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Solicitar aprobación', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> _submitClient() async {
    if (!(_clientForm.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    final msg = await _auth.registerClient(
      name: _cName.text,
      phone: _cPhone.text,
      email: _cEmail.text,
      password: _cPass.text,
    );
    setState(() => _loading = false);
    _show(msg ?? 'Registro completado');
  }

  Future<void> _submitVendor() async {
    if (!(_vendorForm.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    final msg = await _auth.registerVendor(
      name: _vName.text,
      phone: _vPhone.text,
      email: _vEmail.text,
      password: _vPass.text,
      address: _vAddress.text,
      document: _vDocument.text,
      category: _vCategory.text,
      description: _vDescription.text,
      vendorType: _vendorType,
    );
    setState(() => _loading = false);
    _show(msg ?? 'Solicitud enviada');
  }

  void _show(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
