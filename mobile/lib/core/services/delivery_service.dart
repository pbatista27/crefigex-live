import 'dart:convert';

import '../config/api_config.dart';
import 'api_client.dart';
import 'auth_store.dart';

class DeliveryDto {
  final String id;
  final String orderId;
  final String status;
  final String deliveryType;
  final String? photoUrl;
  DeliveryDto({required this.id, required this.orderId, required this.status, required this.deliveryType, this.photoUrl});

  factory DeliveryDto.fromJson(Map<String, dynamic> json) {
    return DeliveryDto(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      status: json['status'] ?? '',
      deliveryType: json['delivery_type'] ?? '',
      photoUrl: json['photo_url'],
    );
  }
}

class DeliveryService {
  final ApiClient _client = ApiClient(baseUrl: ApiConfig.baseUrl);

  Future<List<DeliveryDto>> listMine() async {
    final token = await AuthStore.getToken();
    final res = await _client.get('/me/deliveries', token: token);
    if (res.statusCode != 200) throw Exception('Error al cargar entregas');
    final body = jsonDecode(res.body);
    final list = (body['data'] ?? body) as List<dynamic>;
    return list.map((e) => DeliveryDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> confirmDelivery(String id) async {
    final token = await AuthStore.getToken();
    final res = await _client.post('/deliveries/$id/confirm', {}, token: token);
    if (res.statusCode >= 300) throw Exception('No se pudo confirmar entrega');
  }

  Future<List<DeliveryDto>> listVendor() async {
    final token = await AuthStore.getToken();
    final res = await _client.get('/vendors/me/deliveries', token: token);
    if (res.statusCode != 200) throw Exception('Error al cargar entregas');
    final body = jsonDecode(res.body);
    final list = (body['data'] ?? body) as List<dynamic>;
    return list.map((e) => DeliveryDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> markDelivered(String id, {String? photoUrl}) async {
    final token = await AuthStore.getToken();
    final res = await _client.post('/vendors/me/deliveries/$id/mark-delivered', {'photo_url': photoUrl ?? ''}, token: token);
    if (res.statusCode >= 300) throw Exception('No se pudo marcar entregada');
  }

  Future<void> updateStatus(String id, String status) async {
    final token = await AuthStore.getToken();
    final res = await _client.post('/vendors/me/deliveries/$id/status', {'status': status}, token: token);
    if (res.statusCode >= 300) throw Exception('No se pudo actualizar estado');
  }
}
