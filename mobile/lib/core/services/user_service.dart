import 'dart:convert';

import '../config/api_config.dart';
import 'api_client.dart';
import 'auth_store.dart';

class UserProfile {
  final String id;
  final String email;
  final String name;
  final List<String> roles;
  final String vendorType;
  final String vendorStatus;
  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.roles,
    required this.vendorType,
    required this.vendorStatus,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final rolesRaw = json['roles'] as List<dynamic>? ?? [];
    return UserProfile(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      roles: rolesRaw.map((e) => e.toString()).toList(),
      vendorType: json['vendor_type']?.toString() ?? '',
      vendorStatus: json['vendor_status']?.toString() ?? '',
    );
  }
}

class UserService {
  final ApiClient _client = ApiClient(baseUrl: ApiConfig.baseUrl);

  Future<UserProfile?> me() async {
    final token = await AuthStore.getToken();
    if (token == null) return null;
    final res = await _client.get('/me', token: token);
    if (res.statusCode != 200) return null;
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (body['user'] != null) {
      return UserProfile.fromJson(body['user'] as Map<String, dynamic>);
    }
    return null;
  }
}
