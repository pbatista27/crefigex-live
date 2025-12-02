import 'package:flutter/material.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reseñas')),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (_, i) => ListTile(
          title: Text('Comprador $i'),
          subtitle: const Text('Comentario de compra verificada'),
          trailing: const Icon(Icons.star, color: Colors.amber),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('Calificar'),
        icon: const Icon(Icons.rate_review),
      ),
    );
  }
}
