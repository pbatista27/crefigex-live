import 'dart:convert';

import '../config/api_config.dart';
import 'api_client.dart';
import 'auth_store.dart';

class OrderDto {
  final String id;
  final String vendorId;
  final String status;
  final String deliveryType;
  final String shippingAddress;
  final int total;
  OrderDto({
    required this.id,
    required this.vendorId,
    required this.status,
    required this.deliveryType,
    required this.shippingAddress,
    required this.total,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) {
    return OrderDto(
      id: json['id'] ?? '',
      vendorId: json['vendor_id'] ?? '',
      status: json['status'] ?? '',
      deliveryType: json['delivery_type'] ?? '',
      shippingAddress: json['shipping_address'] ?? '',
      total: json['total'] is int ? json['total'] : (json['total'] as num?)?.toInt() ?? 0,
    );
  }
}

class OrderService {
  final ApiClient _client = ApiClient(baseUrl: ApiConfig.baseUrl);

  Future<OrderDto> checkout({
    required String vendorId,
    required List<Map<String, dynamic>> items,
    required String deliveryType,
    required String shippingAddress,
    String? paymentPlanId,
  }) async {
    final token = await AuthStore.getToken();
    final res = await _client.post('/orders/checkout', {
      'vendor_id': vendorId,
      'items': items,
      'delivery_type': deliveryType,
      'shipping_address': shippingAddress,
      'payment_plan_id': paymentPlanId,
    }, token: token);
    if (res.statusCode >= 300) throw Exception('No se pudo crear la orden');
    final body = jsonDecode(res.body);
    final data = body['order'] ?? body;
    return OrderDto.fromJson(data as Map<String, dynamic>);
  }

  Future<List<OrderDto>> listMine() async {
    final token = await AuthStore.getToken();
    final res = await _client.get('/me/orders', token: token);
    if (res.statusCode != 200) throw Exception('No se pudieron cargar pedidos');
    final body = jsonDecode(res.body);
    final list = (body['data'] ?? body) as List<dynamic>;
    return list.map((e) => OrderDto.fromJson(e as Map<String, dynamic>)).toList();
  }
}
