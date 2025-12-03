import 'package:flutter/material.dart';
import '../../core/services/order_service.dart';
import '../../core/state/user_state.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserState>(context, listen: false);
    if (user.userId == null) {
      return const Scaffold(body: Center(child: Text('Inicia sesión para ver pedidos')));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Mis pedidos')),
      body: FutureBuilder(
        future: OrderService().listMine(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('No se pudieron cargar los pedidos'));
          }
          final orders = snapshot.data ?? <OrderDto>[];
          if (orders.isEmpty) {
            return const Center(child: Text('Sin pedidos aún'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (_, i) => _OrderCard(data: orders[i]),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderDto data;
  const _OrderCard({required this.data});

  @override
  Widget build(BuildContext context) {
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
              const Icon(Icons.receipt_long, color: Color(0xFF6366f1)),
              const SizedBox(width: 8),
              Text(data.id, style: const TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              _StatusBadge(status: data.status),
            ],
          ),
          const SizedBox(height: 8),
          Text('Envío: ${data.deliveryType} · ${data.shippingAddress}', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('\$${data.total}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/deliveries'),
                child: const Text('Ver entrega'),
              )
            ],
          )
        ],
      ),
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
    if (status.contains('APROBADA')) {
      bg = const Color(0xFFDCFCE7);
      fg = const Color(0xFF16A34A);
    } else if (status.contains('PENDIENTE')) {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFFF59E0B);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(status, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}
