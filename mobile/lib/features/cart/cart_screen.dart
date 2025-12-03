import 'package:flutter/material.dart';
import '../../core/services/cart_service.dart';
import '../../core/state/user_state.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _vendorController = TextEditingController(text: CartService.lastVendorId ?? '');
  Future<List<CartItemDto>>? _future;

  @override
  void initState() {
    super.initState();
    if (_vendorController.text.isNotEmpty) {
      _future = CartService().viewCart(_vendorController.text);
    }
  }

  @override
  void dispose() {
    _vendorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserState>(context, listen: false);
    if (user.userId == null) {
      return const Scaffold(body: Center(child: Text('Inicia sesión para ver el carrito')));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _vendorController,
                    decoration: const InputDecoration(
                      labelText: 'ID del vendedor',
                      hintText: 'vendor_id',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_vendorController.text.isEmpty) return;
                    setState(() {
                      _future = CartService().viewCart(_vendorController.text);
                    });
                  },
                  child: const Text('Cargar'),
                )
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _future == null
                  ? const Center(child: Text('Ingresa un vendedor para ver su carrito'))
                  : FutureBuilder(
                      future: _future,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Text('No se pudo cargar el carrito'));
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final items = snapshot.data ?? [];
                        if (items.isEmpty) {
                          return const Center(child: Text('Carrito vacío'));
                        }
                        final subtotal = items.fold<double>(0, (sum, i) => sum + i.total);
                        const delivery = 2.0;
                        final total = subtotal + delivery;
                        return ListView(
                          children: [
                            _CartSection(
                              storeName: 'Carrito vendedor',
                              emoji: '🛍️',
                              items: items,
                            ),
                            const SizedBox(height: 12),
                            _Summary(subtotal: subtotal, delivery: delivery, total: total),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamed(context, '/checkout', arguments: {
                                'vendorId': _vendorController.text,
                                'items': items,
                              }),
                              child: const Text('Continuar al Pago'),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartSection extends StatelessWidget {
  final String storeName;
  final String emoji;
  final List<CartItemDto> items;
  const _CartSection({required this.storeName, required this.emoji, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFfed7aa), Color(0xFFfdba74)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 10),
                Text(storeName, style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const Divider(height: 1),
          ...items.map((item) => _CartItem(
                name: item.productId ?? 'Servicio',
                unit: item.serviceId ?? item.productId ?? '',
                price: item.unitPrice.toDouble(),
                qty: item.quantity,
              )),
        ],
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final String name;
  final String unit;
  final double price;
  final int qty;
  const _CartItem({required this.name, required this.unit, required this.price, required this.qty});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(child: Text('🛒')),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(unit, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('\$${(price * qty).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700)),
              Row(
                children: [
                  _QtyBtn(icon: Icons.remove, onTap: () {}),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  _QtyBtn(icon: Icons.add, onTap: () {}),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  final double subtotal;
  final double delivery;
  final double total;
  const _Summary({required this.subtotal, required this.delivery, required this.total});

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
          _row('Subtotal', subtotal),
          _row('Delivery', delivery),
          const Divider(),
          _row('Total', total, bold: true),
        ],
      ),
    );
  }

  Widget _row(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: const Color(0xFF475569), fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
          const Spacer(),
          Text('\$${value.toStringAsFixed(2)}', style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w700)),
        ],
      ),
    );
  }
}
