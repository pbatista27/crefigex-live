import 'package:flutter/material.dart';
import '../../core/services/order_service.dart';
import '../../core/services/cart_service.dart';
import '../../core/state/user_state.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserState>(context, listen: false);
    if (user.userId == null) {
      return const Scaffold(body: Center(child: Text('Inicia sesión para continuar')));
    }
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final vendorId = args['vendorId'] as String? ?? CartService.lastVendorId ?? '';
    final items = (args['items'] as List<dynamic>?)
            ?.map((e) => {
                  'product_id': (e as dynamic).productId,
                  'service_id': (e as dynamic).serviceId,
                  'quantity': (e as dynamic).quantity,
                  'unit_price': (e as dynamic).unitPrice,
                  'total': (e as dynamic).total,
                })
            .toList() ??
        [];
    final addressCtrl = TextEditingController();
    final vendorCtrl = TextEditingController(text: vendorId);
    String deliveryType = 'INTERNAL';
    String? plan;
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: vendorCtrl,
            decoration: const InputDecoration(labelText: 'ID del vendedor', border: OutlineInputBorder()),
            onChanged: (_) {},
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'Entrega',
            child: _DeliveryCard(
              onTypeChanged: (v) => deliveryType = v,
            ),
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'Método de pago',
            child: _PaymentOptions(),
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'Plan BNPL',
            child: DropdownButtonFormField(
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Selecciona plan'),
              items: const [
                DropdownMenuItem(value: '7', child: Text('Plan 7 días')),
                DropdownMenuItem(value: '15', child: Text('Plan 15 días')),
              ],
              onChanged: (v) => plan = v,
            ),
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'Dirección',
            child: TextField(
              controller: addressCtrl,
              decoration: const InputDecoration(
                labelText: 'Dirección de envío',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _Summary(total: 10.8),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              if (vendorCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Falta vendor_id')));
                return;
              }
              if (items.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Carrito vacío para este vendedor')));
                return;
              }
              try {
                final order = await OrderService().checkout(
                  vendorId: vendorCtrl.text,
                  items: items,
                  deliveryType: deliveryType,
                  shippingAddress: addressCtrl.text.isEmpty ? 'Dirección no especificada' : addressCtrl.text,
                  paymentPlanId: plan,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Orden creada: ${order.id}')),
                );
                Navigator.pushNamed(context, '/payments');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: const Text('Confirmar orden'),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _DeliveryCard extends StatelessWidget {
  final ValueChanged<String>? onTypeChanged;
  const _DeliveryCard({this.onTypeChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          RadioListTile<String>(
            value: 'INTERNAL',
            groupValue: 'INTERNAL',
            onChanged: (v) => onTypeChanged?.call(v ?? 'INTERNAL'),
            title: const Text('Entrega interna del comercio'),
            subtitle: const Text('Coordinas directamente con el vendedor'),
            activeColor: const Color(0xFF6366f1),
          ),
          RadioListTile<String>(
            value: 'CREFIGEX',
            groupValue: '',
            onChanged: (v) => onTypeChanged?.call(v ?? 'CREFIGEX'),
            title: const Text('Entrega por Crefigex'),
            subtitle: const Text('Seguimiento y logística gestionada por Crefigex'),
            activeColor: const Color(0xFF6366f1),
          ),
        ],
      ),
    );
  }
}

class _PaymentOptions extends StatefulWidget {
  @override
  State<_PaymentOptions> createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<_PaymentOptions> {
  String selected = 'cuotas';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PaymentTile(
          title: 'Pagar en Cuotas',
          subtitle: '2 cuotas sin intereses',
          emoji: '💳',
          selected: selected == 'cuotas',
          onTap: () => setState(() => selected = 'cuotas'),
        ),
        const SizedBox(height: 8),
        _PaymentTile(
          title: 'Pago de Contado',
          subtitle: 'Pago Móvil, Zelle, Efectivo',
          emoji: '💵',
          selected: selected == 'contado',
          onTap: () => setState(() => selected = 'contado'),
        ),
      ],
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;
  const _PaymentTile({required this.title, required this.subtitle, required this.emoji, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? const Color(0xFF6366f1) : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(subtitle, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: selected ? const Color(0xFF6366f1) : const Color(0xFFE2E8F0), width: 2),
              ),
              child: selected ? const Center(child: Icon(Icons.check, size: 14, color: Color(0xFF6366f1))) : null,
            )
          ],
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final double total;
  const _Summary({required this.total});
  @override
  Widget build(BuildContext context) {
    final items = ModalRoute.of(context)?.settings.arguments is Map
        ? ((ModalRoute.of(context)?.settings.arguments as Map?)?['items'] as List<dynamic>?)
        : null;
    final subtotal = items?.fold<double>(0, (sum, e) => sum + ((e as dynamic).total ?? 0)) ?? total;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Total', style: TextStyle(color: Color(0xFF94A3B8))),
              SizedBox(height: 4),
            ],
          ),
          const Spacer(),
          Text('\$${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
        ],
      ),
    );
  }
}
