import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client _client = http.Client();

  ApiClient({required this.baseUrl});

  Future<http.Response> get(String path) => _client.get(Uri.parse('$baseUrl$path'));

  Future<http.Response> post(String path, Map<String, dynamic> data) {
    return _client.post(
      Uri.parse('$baseUrl$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }
}
