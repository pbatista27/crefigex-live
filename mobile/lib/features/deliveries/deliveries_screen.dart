import 'package:flutter/material.dart';
import '../../core/data/sample_data.dart';
import '../../core/services/delivery_service.dart';
import '../../core/state/user_state.dart';
import 'package:provider/provider.dart';

class DeliveriesScreen extends StatelessWidget {
  const DeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserState>(context, listen: false);
    if (user.userId == null) {
      return const Scaffold(body: Center(child: Text('Inicia sesión para ver entregas')));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Mis entregas')),
      body: FutureBuilder(
        future: DeliveryService().listMine(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('No hay entregas'));
          }
          final deliveries = snapshot.data ?? [];
          if (deliveries.isEmpty) {
            return const Center(child: Text('No hay entregas'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: deliveries.length,
            itemBuilder: (_, i) => _DeliveryCard(data: deliveries[i]),
          );
        },
      ),
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final dynamic data; // SampleDelivery o DeliveryDto
  const _DeliveryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final type = data is SampleDelivery ? data.type : (data.deliveryType ?? 'INTERNAL');
    final status = data is SampleDelivery ? data.status : data.status;
    final orderId = data is SampleDelivery ? data.orderId : data.orderId;
    final accent = type == 'CREFIGEX' ? const Color(0xFF0EA5E9) : const Color(0xFF6366f1);
    final photoUrl = data is SampleDelivery ? data.photo : data.photoUrl;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: accent.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Text(type == 'CREFIGEX' ? '🚚' : '🏪', style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 10),
                Text(type == 'CREFIGEX' ? 'Crefigex Logistics' : 'Entrega interna', style: const TextStyle(fontWeight: FontWeight.w700)),
                const Spacer(),
                _Badge(text: type),
              ],
            ),
            const SizedBox(height: 10),
            Text('Entrega ${data.id}', style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('Orden $orderId', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
            const SizedBox(height: 8),
            if (photoUrl != null && photoUrl.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(photoUrl, height: 140, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                _StatusBadge(status: status),
                const Spacer(),
                if (status == 'DELIVERED' || status == 'PENDING_DELIVERY')
                  ElevatedButton(
                  onPressed: () async {
                    try {
                      await DeliveryService().confirmDelivery(data.id);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entrega confirmada')));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  child: const Text('Confirmar'),
                ),
            ],
          )
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});
  @override
  Widget build(BuildContext context) {
    Color bg = const Color(0xFFE0F2FE);
    Color fg = const Color(0xFF0EA5E9);
    if (status.contains('PENDING')) {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFFF59E0B);
    } else if (status.contains('DELIVERED')) {
      bg = const Color(0xFFDCFCE7);
      fg = const Color(0xFF16A34A);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(status, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}
