import 'package:flutter/material.dart';
import '../../core/data/sample_data.dart';
import '../../core/services/video_service.dart';

class VideoListScreen extends StatelessWidget {
  const VideoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos en vivo'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFF7F7F9),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder(
            future: VideoService().listPublic(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('No hay videos disponibles'));
              }
              final videos = snapshot.data ?? [];
              if (videos.isEmpty) {
                return const Center(child: Text('No hay videos publicados'));
              }
              return GridView.builder(
                itemCount: videos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (_, i) {
                  final v = videos[i] as VideoItem;
                  final live = false;
                  final vendor = v.vendorId;
                  final title = v.title;
                  return _VideoCard(
                    title: title,
                    badge: live ? 'LIVE' : 'REPLAY',
                    views: live ? '1.2k' : '845',
                    vendor: vendor,
                    onTap: () => Navigator.pushNamed(context, '/video', arguments: v),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/chat'),
        icon: const Icon(Icons.chat),
        label: const Text('Chat'),
        backgroundColor: const Color(0xFF0E9384),
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final String title;
  final String vendor;
  final String badge;
  final String views;
  final VoidCallback onTap;
  const _VideoCard({required this.title, required this.vendor, required this.onTap, required this.badge, required this.views});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF0E9384);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFfb923c), Color(0xFFc2410c)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  const Center(
                    child: Icon(Icons.play_circle_fill, size: 52, color: Colors.white),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _Badge(text: badge, live: badge == 'LIVE'),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 6),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.visibility, size: 14, color: Colors.black87),
                          const SizedBox(width: 4),
                          Text(views),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(vendor, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _Badge(text: badge, live: badge == 'LIVE'),
                    const Icon(Icons.remove_red_eye, size: 16, color: accent),
                    Text('Ver ahora · $views', style: const TextStyle(color: accent)),
                  ],
                )
              ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final bool live;
  const _Badge({required this.text, this.live = false});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF0E9384);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: live ? const Color(0xFFef4444) : accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: live ? Colors.white : accent, fontSize: 12, fontWeight: live ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
