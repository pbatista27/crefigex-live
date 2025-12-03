import 'package:shared_preferences/shared_preferences.dart';

class AuthStore {
  static const _key = 'crefigex_token';
  static String? _cached;

  static Future<String?> getToken() async {
    if (_cached != null) return _cached;
    final prefs = await SharedPreferences.getInstance();
    _cached = prefs.getString(_key);
    return _cached;
  }

  static Future<void> saveToken(String token) async {
    _cached = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  static Future<void> clear() async {
    _cached = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
