import 'dart:convert';
import '../config/api_config.dart';
import 'api_client.dart';
import 'auth_store.dart';

class ChatMessageDto {
  final String id;
  final String senderId;
  final String senderRole;
  final String message;
  final String createdAt;
  ChatMessageDto({
    required this.id,
    required this.senderId,
    required this.senderRole,
    required this.message,
    required this.createdAt,
  });

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) {
    return ChatMessageDto(
      id: json['id'] ?? '',
      senderId: json['sender_id'] ?? '',
      senderRole: json['sender_role'] ?? '',
      message: json['message'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class ChatService {
  final ApiClient _client = ApiClient(baseUrl: ApiConfig.baseUrl);

  Future<List<ChatMessageDto>> listMessages(String videoId, {String? since}) async {
    final qs = since != null && since.isNotEmpty ? '?since=$since' : '';
    final res = await _client.get('/videos/$videoId/chat/messages$qs');
    if (res.statusCode != 200) throw Exception('No se pudo cargar chat');
    final body = jsonDecode(res.body);
    final list = (body['data'] ?? body) as List<dynamic>;
    return list.map((e) => ChatMessageDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> sendMessage(String videoId, String message) async {
    final token = await AuthStore.getToken();
    final res = await _client.post('/videos/$videoId/chat/messages', {'message': message}, token: token);
    if (res.statusCode >= 300) throw Exception('No se pudo enviar el mensaje');
  }
}
