import 'dart:convert';

import '../config/api_config.dart';
import 'api_client.dart';
import 'auth_store.dart';

class AppointmentDto {
  final String id;
  final String serviceId;
  final String vendorId;
  final String scheduledAt;
  final String status;
  AppointmentDto({
    required this.id,
    required this.serviceId,
    required this.vendorId,
    required this.scheduledAt,
    required this.status,
  });

  factory AppointmentDto.fromJson(Map<String, dynamic> json) {
    return AppointmentDto(
      id: json['id'] ?? '',
      serviceId: json['service_id'] ?? '',
      vendorId: json['vendor_id'] ?? '',
      scheduledAt: json['scheduled_at'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class AppointmentService {
  final ApiClient _client = ApiClient(baseUrl: ApiConfig.baseUrl);

  Future<List<AppointmentDto>> listMine() async {
    final token = await AuthStore.getToken();
    final res = await _client.get('/me/appointments', token: token);
    if (res.statusCode != 200) throw Exception('Error al cargar citas');
    final body = jsonDecode(res.body);
    final list = (body['data'] ?? body) as List<dynamic>;
    return list.map((e) => AppointmentDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<String>> availableSlots(String serviceId) async {
    final token = await AuthStore.getToken();
    final res = await _client.get('/services/$serviceId/available-slots', token: token);
    if (res.statusCode != 200) throw Exception('No se pudieron cargar los horarios');
    final body = jsonDecode(res.body);
    final slots = (body['slots'] ?? body) as List<dynamic>;
    return slots.map((e) => e.toString()).toList();
  }

  Future<void> createAppointment({
    required String serviceId,
    required String vendorId,
    required String slot,
  }) async {
    final token = await AuthStore.getToken();
    final res = await _client.post('/appointments', {
      'service_id': serviceId,
      'vendor_id': vendorId,
      'scheduled_at': slot,
      'status': 'PENDING',
    }, token: token);
    if (res.statusCode >= 300) {
      throw Exception('No se pudo agendar la cita');
    }
  }
}
