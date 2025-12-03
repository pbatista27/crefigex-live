import 'dart:convert';

import '../config/api_config.dart';
import 'api_client.dart';
import 'auth_store.dart';

class InstallmentDto {
  final String id;
  final String orderId;
  final int amount;
  final String dueDate;
  final bool paid;
  InstallmentDto({required this.id, required this.orderId, required this.amount, required this.dueDate, required this.paid});

  factory InstallmentDto.fromJson(Map<String, dynamic> json) {
    return InstallmentDto(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      amount: json['amount'] is int ? json['amount'] : int.tryParse(json['amount']?.toString() ?? '0') ?? 0,
      dueDate: json['due_date'] ?? '',
      paid: json['paid'] == true,
    );
  }
}

class PaymentService {
  final ApiClient _client = ApiClient(baseUrl: ApiConfig.baseUrl);

  Future<List<InstallmentDto>> listMyInstallments() async {
    final token = await AuthStore.getToken();
    final res = await _client.get('/me/installments', token: token);
    if (res.statusCode != 200) throw Exception('Error al cargar cuotas');
    final body = jsonDecode(res.body);
    final list = (body['data'] ?? body) as List<dynamic>;
    return list.map((e) => InstallmentDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> registerPayment({
    required String orderId,
    String? installmentId,
    required int amount,
    required String method,
    String? reference,
    String? bankOrigin,
    String? bankDest,
  }) async {
    final token = await AuthStore.getToken();
    final res = await _client.post('/orders/$orderId/payments', {
      'installment_id': installmentId,
      'amount': amount,
      'method': method,
      'reference': reference,
      'bank_origin': bankOrigin,
      'bank_dest': bankDest,
    }, token: token);
    if (res.statusCode >= 300) throw Exception('No se pudo registrar el pago');
  }
}
