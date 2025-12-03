import 'package:flutter/material.dart';
import '../../core/services/video_service.dart';

class VideoDetailScreen extends StatelessWidget {
  const VideoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videoArg = ModalRoute.of(context)?.settings.arguments;
    final video = videoArg is VideoItem ? videoArg : null;
    final videoId = videoArg is String ? videoArg : video?.id ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(video?.title ?? 'Detalle de video')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 180, color: Colors.black12, child: const Center(child: Text('Player'))),
            const SizedBox(height: 12),
            Text(video?.title ?? 'Título del video $videoId', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Vendedor: ${video?.vendorId ?? '—'}'),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/cart'), child: const Text('Agregar al carrito')),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: () => Navigator.pushNamed(context, '/reviews', arguments: video?.id ?? videoId), child: const Text('Ver reseñas')),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: () => Navigator.pushNamed(context, '/chat', arguments: video?.id ?? videoId), child: const Text('Chat en vivo')),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Productos/servicios asociados se mostrarán aquí cuando la API los expose.', style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
