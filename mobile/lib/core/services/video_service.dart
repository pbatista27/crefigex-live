import 'dart:convert';
import '../config/api_config.dart';
import 'api_client.dart';
import 'auth_store.dart';

class VideoItem {
  final String id;
  final String title;
  final String description;
  final String url;
  final String vendorId;
  VideoItem({required this.id, required this.title, required this.description, required this.url, required this.vendorId});

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      vendorId: json['vendor_id']?.toString() ?? '',
    );
  }
}

class VideoService {
  final ApiClient _client = ApiClient(baseUrl: ApiConfig.baseUrl);

  Future<List<VideoItem>> listPublic() async {
    final res = await _client.get('/videos');
    if (res.statusCode != 200) throw Exception('Error al cargar videos');
    final body = jsonDecode(res.body);
    final list = (body['data'] ?? body) as List<dynamic>;
    return list.map((e) => VideoItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<VideoItem?> getById(String id) async {
    final res = await _client.get('/videos/$id');
    if (res.statusCode != 200) return null;
    final body = jsonDecode(res.body);
    final data = body['video'] ?? body;
    return VideoItem.fromJson(data as Map<String, dynamic>);
  }

  Future<void> sendChatMessage(String videoId, String message) async {
    final token = await AuthStore.getToken();
    final res = await _client.post('/videos/$videoId/chat/messages', {'message': message}, token: token);
    if (res.statusCode >= 300) throw Exception('No se pudo enviar el mensaje');
  }
}
