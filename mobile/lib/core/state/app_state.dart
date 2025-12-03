import 'package:flutter/material.dart';
import '../services/auth_store.dart';
import '../services/auth_service.dart';

class AppState extends ChangeNotifier {
  String? _token;
  bool _initialized = false;
  final _authService = AuthService();

  String? get token => _token;
  bool get initialized => _initialized;

  AppState() {
    _load();
  }

  Future<void> _load() async {
    _token = await AuthStore.getToken();
    if (_token != null) {
      final refreshed = await _authService.refresh(_token!);
      if (refreshed != null && refreshed.isNotEmpty) {
        _token = refreshed;
        await AuthStore.saveToken(refreshed);
      }
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> setToken(String? token) async {
    _token = token;
    if (token == null || token.isEmpty) {
      await AuthStore.clear();
    } else {
      await AuthStore.saveToken(token);
    }
    notifyListeners();
  }
}
