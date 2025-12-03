import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_store.dart';

class ApiClient {
  final String baseUrl;
  final http.Client _client = http.Client();

  ApiClient({required this.baseUrl});

  Future<http.Response> get(String path, {String? token}) => _send('GET', path, token: token);

  Future<http.Response> post(String path, Map<String, dynamic> data, {String? token}) =>
      _send('POST', path, data: data, token: token);

  Future<http.Response> _send(String method, String path, {Map<String, dynamic>? data, String? token, bool retry = false}) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = _headers(token);
    http.Response res;
    if (method == 'GET') {
      res = await _client.get(uri, headers: headers);
    } else {
      res = await _client.post(uri, headers: headers, body: jsonEncode(data ?? {}));
    }
    if (res.statusCode == 401 && !retry) {
      final newToken = await _handle401(token);
      if (newToken != null && newToken.isNotEmpty) {
        return _send(method, path, data: data, token: newToken, retry: true);
      }
    }
    return res;
  }

  Map<String, String> _headers(String? token) => {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

  Future<String?> _handle401(String? token) async {
    if (token == null || token.isEmpty) {
      await AuthStore.clear();
      return null;
    }
    try {
      final res = await _client.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: _headers(token),
      );
      if (res.statusCode != 200) {
        await AuthStore.clear();
        return null;
      }
      final body = jsonDecode(res.body);
      final newToken = body['token'] as String?;
      if (newToken != null && newToken.isNotEmpty) {
        await AuthStore.saveToken(newToken);
      }
      return newToken;
    } catch (_) {
      await AuthStore.clear();
      return null;
    }
  }
}
