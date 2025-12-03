import 'package:flutter/material.dart';
import '../../core/services/review_service.dart';
import '../../core/state/user_state.dart';
import 'package:provider/provider.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final _reviewService = ReviewService();
  final _controller = TextEditingController();
  int _rating = 5;

  @override
  Widget build(BuildContext context) {
    final videoId = (ModalRoute.of(context)?.settings.arguments as String?) ?? 'v1';
    final user = Provider.of<UserState>(context, listen: false);
    if (user.userId == null) {
      return const Scaffold(body: Center(child: Text('Inicia sesión para ver/crear reseñas')));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Reseñas')),
      body: FutureBuilder(
        future: _reviewService.listVideoReviews(videoId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('No hay reseñas'));
          }
          final reviews = snapshot.data ?? [];
          if (reviews.isEmpty) {
            return const Center(child: Text('No hay reseñas'));
          }
          return ListView.separated(
            itemCount: reviews.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final r = reviews[i];
              return ListTile(
                title: Text(r.userId.isEmpty ? 'Comprador' : r.userId),
                subtitle: Text(r.comment),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (s) => Icon(Icons.star, size: 18, color: s < r.rating ? Colors.amber : Colors.grey.shade300)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showReviewDialog(context, videoId),
        label: const Text('Calificar'),
        icon: const Icon(Icons.rate_review),
      ),
    );
  }

  void _showReviewDialog(BuildContext context, String videoId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Calificar video'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: List.generate(5, (i) => IconButton(
                    onPressed: () => setState(() => _rating = i + 1),
                    icon: Icon(
                      Icons.star,
                      color: i < _rating ? Colors.amber : Colors.grey.shade300,
                    ),
                  )),
            ),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Comentario'),
            )
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _reviewService.createVideoReview(videoId, _rating, _controller.text);
                if (mounted) {
                  Navigator.pop(context);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reseña enviada')));
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}
