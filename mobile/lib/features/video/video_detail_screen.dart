import 'package:flutter/material.dart';

class VideoDetailScreen extends StatelessWidget {
  const VideoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de video')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 180, color: Colors.black12, child: const Center(child: Text('Player'))),
            const SizedBox(height: 12),
            const Text('Título del video', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Descripción del video y productos/servicios asociados.'),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/cart'), child: const Text('Agregar al carrito')),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: () => Navigator.pushNamed(context, '/reviews'), child: const Text('Ver reseñas')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
