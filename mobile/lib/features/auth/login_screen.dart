import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/services/auth_service.dart';
import '../../core/state/app_state.dart';
import '../../core/state/user_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _auth = AuthService();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0e7ff), Color(0xFFf8fafc)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366f1).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.lock_open_rounded, size: 34, color: Color(0xFF6366f1)),
                ),
                const SizedBox(height: 12),
                const Text('Iniciar sesión', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                const Text('Accede a compras, BNPL y panel de vendedor.', style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 8,
                  shadowColor: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _emailCtrl,
                            decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline)),
                            validator: (v) => v != null && v.contains('@') ? null : 'Email inválido',
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passCtrl,
                            decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock_outline)),
                            obscureText: true,
                            validator: (v) => v != null && v.length >= 6 ? null : 'Mínimo 6 caracteres',
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366f1),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: _loading ? null : _submit,
                            child: _loading
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text('Entrar', style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/register'),
                            child: const Text('¿No tienes cuenta? Regístrate'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    final msg = await _auth.login(email: _emailCtrl.text, password: _passCtrl.text);
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg ?? 'Inicio de sesión')));
    if (msg != null && !msg.toLowerCase().contains('error')) {
      await Provider.of<AppState>(context, listen: false).setToken(msg);
      await Provider.of<UserState>(context, listen: false).loadFromToken();
      Navigator.pushReplacementNamed(context, '/');
    }
  }
}
