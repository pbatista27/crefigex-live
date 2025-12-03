import 'dart:convert';

import '../config/api_config.dart';
import 'api_client.dart';
import 'auth_store.dart';

class CartItemDto {
  final String id;
  final String vendorId;
  final String? productId;
  final String? serviceId;
  final int quantity;
  final int unitPrice;
  final int total;
  CartItemDto({
    required this.id,
    required this.vendorId,
    this.productId,
    this.serviceId,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  factory CartItemDto.fromJson(Map<String, dynamic> json) {
    return CartItemDto(
      id: json['id'] ?? '',
      vendorId: json['vendor_id'] ?? '',
      productId: json['product_id'],
      serviceId: json['service_id'],
      quantity: json['quantity'] ?? 0,
      unitPrice: json['unit_price'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class CartService {
  final ApiClient _client = ApiClient(baseUrl: ApiConfig.baseUrl);
  static String? lastVendorId;

  Future<void> addItem({
    required String vendorId,
    String? productId,
    String? serviceId,
    required int quantity,
    required int unitPrice,
  }) async {
    final token = await AuthStore.getToken();
    final res = await _client.post('/cart/items', {
      'vendor_id': vendorId,
      'product_id': productId,
      'service_id': serviceId,
      'quantity': quantity,
      'unit_price': unitPrice,
    }, token: token);
    if (res.statusCode >= 300) throw Exception('No se pudo agregar al carrito');
    lastVendorId = vendorId;
  }

  Future<List<CartItemDto>> viewCart(String vendorId) async {
    lastVendorId = vendorId;
    final token = await AuthStore.getToken();
    final res = await _client.get('/cart?vendor_id=$vendorId', token: token);
    if (res.statusCode != 200) throw Exception('No se pudo cargar el carrito');
    final body = jsonDecode(res.body);
    final list = (body['items'] ?? body) as List<dynamic>;
    return list.map((e) => CartItemDto.fromJson(e as Map<String, dynamic>)).toList();
  }
}
