import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'api_client.dart';
import 'auth_store.dart';

class AuthService {
  final ApiClient _client = ApiClient(baseUrl: ApiConfig.baseUrl);

  Future<String?> registerClient({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    final res = await _client.post('/auth/register', {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'roles': ['CLIENTE'],
    });
    return _handle(res);
  }

  Future<String?> registerVendor({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String address,
    required String document,
    required String category,
    required String description,
    required String vendorType,
  }) async {
    // En un backend real, el registro de vendedor podría ser 2 pasos:
    // 1) Crear usuario con rol VENDEDOR
    // 2) Crear vendor profile
    // Aquí asumimos un endpoint combinado; ajusta según tu API.
    final res = await _client.post('/auth/register', {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      'roles': ['VENDEDOR'],
      'vendor': {
        'vendor_type': vendorType,
        'address': address,
        'document': document,
        'category': category,
        'description': description,
        'name': name,
      }
    });
    return _handle(res);
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final res = await _client.post('/auth/login', {
      'email': email,
      'password': password,
    });
    return _handle(res);
  }

  Future<void> logout() async {
    await AuthStore.clear();
  }

  Future<String?> refresh(String token) async {
    final res = await _client.post('/auth/refresh', {}, token: token);
    if (res.statusCode < 200 || res.statusCode >= 300) return null;
    try {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final newToken = body['token']?.toString();
      if (newToken != null && newToken.isNotEmpty) {
        await AuthStore.saveToken(newToken);
      }
      return newToken;
    } catch (_) {
      return null;
    }
  }

  String? _handle(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      try {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        return body['token']?.toString() ?? 'Registrado correctamente';
      } catch (_) {
        return 'Registrado correctamente';
      }
    }
    return 'Error ${res.statusCode}: ${res.body}';
  }
}
