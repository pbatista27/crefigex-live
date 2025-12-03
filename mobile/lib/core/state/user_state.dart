import 'package:flutter/material.dart';
import '../services/auth_store.dart';
import '../services/user_service.dart';

class UserState extends ChangeNotifier {
  String? _userId;
  String _email = '';
  String _name = '';
  List<String> _roles = [];
  String _vendorType = '';
  String _vendorStatus = '';
  final _userService = UserService();

  String? get userId => _userId;
  String get email => _email;
  String get name => _name;
  List<String> get roles => _roles;
  String get vendorType => _vendorType;
  String get vendorStatus => _vendorStatus;

  Future<void> loadFromToken() async {
    final token = await AuthStore.getToken();
    if (token == null) return;
    final profile = await _userService.me();
    if (profile != null) {
      _userId = profile.id;
      _email = profile.email;
      _name = profile.name;
      _roles = profile.roles;
      _vendorType = profile.vendorType;
      _vendorStatus = profile.vendorStatus;
      notifyListeners();
    }
  }

  void clear() {
    _userId = null;
    _email = '';
    _name = '';
    _roles = [];
    _vendorType = '';
    _vendorStatus = '';
    notifyListeners();
  }
}
