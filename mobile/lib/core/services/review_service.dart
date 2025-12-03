import 'dart:convert';
import '../config/api_config.dart';
import 'api_client.dart';
import 'auth_store.dart';

class ReviewDto {
  final String id;
  final String userId;
  final int rating;
  final String comment;
  ReviewDto({required this.id, required this.userId, required this.rating, required this.comment});

  factory ReviewDto.fromJson(Map<String, dynamic> json) {
    return ReviewDto(
      id: json['id'] ?? '',
      userId: json['customer_id'] ?? '',
      rating: json['rating'] is int ? json['rating'] : int.tryParse(json['rating']?.toString() ?? '0') ?? 0,
      comment: json['comment'] ?? '',
    );
  }
}

class ReviewService {
  final ApiClient _client = ApiClient(baseUrl: ApiConfig.baseUrl);

  Future<List<ReviewDto>> listVideoReviews(String videoId) async {
    final res = await _client.get('/videos/$videoId/reviews');
    if (res.statusCode != 200) throw Exception('Error al cargar reseñas');
    final body = jsonDecode(res.body);
    final list = (body['data'] ?? body) as List<dynamic>;
    return list.map((e) => ReviewDto.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> createVideoReview(String videoId, int rating, String comment) async {
    final token = await AuthStore.getToken();
    final res = await _client.post('/videos/$videoId/reviews', {'rating': rating, 'comment': comment}, token: token);
    if (res.statusCode >= 300) throw Exception('No se pudo crear la reseña');
  }
}
