import 'dart:convert';

import '../config/api_config.dart';
import 'api_client.dart';
import 'auth_store.dart';

class ProductDto {
  final String id;
  final String name;
  final String vendorId;
  final String vendorName;
  final String categoryId;
  final int price;
  final int stock;

  ProductDto({
    required this.id,
    required this.name,
    required this.vendorId,
    required this.vendorName,
    required this.categoryId,
    required this.price,
    required this.stock,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    final priceRaw = json['price'];
    final stockRaw = json['stock'];
    return ProductDto(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      vendorId: json['vendor_id']?.toString() ?? '',
      vendorName: json['vendor_name'] ?? json['vendor_id']?.toString() ?? 'Vendedor',
      categoryId: json['category_id']?.toString() ?? '',
      price: priceRaw is int ? priceRaw : (priceRaw as num?)?.toInt() ?? 0,
      stock: stockRaw is int ? stockRaw : (stockRaw as num?)?.toInt() ?? 0,
    );
  }
}

class ServiceCatalogDto {
  final String id;
  final String name;
  final String vendorId;
  final String vendorName;
  final String serviceType;
  final int price;

  ServiceCatalogDto({
    required this.id,
    required this.name,
    required this.vendorId,
    required this.vendorName,
    required this.serviceType,
    required this.price,
  });

  factory ServiceCatalogDto.fromJson(Map<String, dynamic> json) {
    final priceRaw = json['price'];
    return ServiceCatalogDto(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      vendorId: json['vendor_id']?.toString() ?? '',
      vendorName: json['vendor_name'] ?? json['vendor_id']?.toString() ?? 'Vendedor',
      serviceType: json['service_type'] ?? '',
      price: priceRaw is int ? priceRaw : (priceRaw as num?)?.toInt() ?? 0,
    );
  }
}

class CatalogService {
  final ApiClient _client = ApiClient(baseUrl: ApiConfig.baseUrl);

  Future<List<ProductDto>> listProducts() async {
    final token = await AuthStore.getToken();
    final res = await _client.get('/catalog/products', token: token);
    if (res.statusCode != 200) throw Exception('Error al listar productos');
    final body = jsonDecode(res.body);
    final list = (body['data'] ?? body) as List<dynamic>;
    return list.map((e) => ProductDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<ServiceCatalogDto>> listServices() async {
    final token = await AuthStore.getToken();
    final res = await _client.get('/catalog/services', token: token);
    if (res.statusCode != 200) throw Exception('Error al listar servicios');
    final body = jsonDecode(res.body);
    final list = (body['data'] ?? body) as List<dynamic>;
    return list.map((e) => ServiceCatalogDto.fromJson(e as Map<String, dynamic>)).toList();
  }
}
