import 'package:flutter/material.dart';
import '../../core/services/appointment_service.dart';
import '../../core/services/cart_service.dart';
import '../../core/services/catalog_service.dart';
import '../../core/state/user_state.dart';
import 'package:provider/provider.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> with SingleTickerProviderStateMixin {
  late TabController controller;
  final _catalogService = CatalogService();
  late Future<List<ProductDto>> productsFuture;
  late Future<List<ServiceCatalogDto>> servicesFuture;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    productsFuture = _catalogService.listProducts();
    servicesFuture = _catalogService.listServices();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
        bottom: TabBar(
          controller: controller,
          tabs: const [
            Tab(text: 'Productos'),
            Tab(text: 'Servicios'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TabBarView(
          controller: controller,
          children: [
            FutureBuilder(
              future: productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('No hay productos'));
                }
                final products = snapshot.data ?? <ProductDto>[];
                if (products.isEmpty) {
                  return const Center(child: Text('No hay productos'));
                }
                return GridView.builder(
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (_, i) => _ProductCard(product: products[i]),
                );
              },
            ),
            FutureBuilder(
              future: servicesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('No hay servicios'));
                }
                final services = snapshot.data ?? <ServiceCatalogDto>[];
                if (services.isEmpty) {
                  return const Center(child: Text('No hay servicios'));
                }
                return ListView.separated(
                  itemBuilder: (_, i) => _ServiceTile(service: services[i]),
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: services.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductDto product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF6366f1);
    final user = Provider.of<UserState>(context, listen: false);
    final outOfStock = product.stock <= 0;
    final source = product.categoryId.isNotEmpty ? product.categoryId : product.name;
    final badge = source.isNotEmpty ? source[0].toUpperCase() : '?';
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/video'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: Center(child: Text(badge, style: const TextStyle(fontSize: 42))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(product.vendorName, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                  const SizedBox(height: 8),
                  Text(
                    outOfStock ? 'Agotado' : 'Stock: ${product.stock}',
                    style: TextStyle(
                      color: outOfStock ? Colors.redAccent : const Color(0xFF0f172a),
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('\$${product.price}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: accent)),
                      const Spacer(),
                      IconButton(
                        onPressed: outOfStock
                            ? null
                            : () async {
                                if (user.userId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inicia sesión para comprar')));
                                  Navigator.pushNamed(context, '/login');
                                  return;
                                }
                                try {
                                  await CartService().addItem(
                                    vendorId: product.vendorId,
                                    productId: product.id,
                                    quantity: 1,
                                    unitPrice: product.price,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Agregado al carrito')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: ${e.toString()}')),
                                  );
                                }
                              },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(outOfStock ? Colors.grey[300] : accent),
                          foregroundColor: MaterialStateProperty.all(outOfStock ? Colors.black38 : Colors.white),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        ),
                        icon: const Icon(Icons.add, size: 16),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final ServiceCatalogDto service;
  const _ServiceTile({required this.service});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      title: Text(service.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('${service.vendorName} · ${service.serviceType}'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('\$${service.price}', style: const TextStyle(fontWeight: FontWeight.bold)),
          TextButton(
            onPressed: () => _openSlotPicker(context, service),
            child: const Text('Agendar'),
          ),
        ],
      ),
    );
  }

  void _openSlotPicker(BuildContext context, ServiceCatalogDto service) {
    final user = Provider.of<UserState>(context, listen: false);
    if (user.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inicia sesión para agendar')));
      Navigator.pushNamed(context, '/login');
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _SlotPickerSheet(service: service),
      ),
    );
  }
}

class _SlotPickerSheet extends StatefulWidget {
  final ServiceCatalogDto service;
  const _SlotPickerSheet({required this.service});

  @override
  State<_SlotPickerSheet> createState() => _SlotPickerSheetState();
}

class _SlotPickerSheetState extends State<_SlotPickerSheet> {
  final _appointments = AppointmentService();
  late Future<List<String>> slotsFuture;
  bool booking = false;

  @override
  void initState() {
    super.initState();
    slotsFuture = _appointments.availableSlots(widget.service.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Horarios disponibles', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(widget.service.name, style: const TextStyle(color: Color(0xFF94A3B8))),
            const SizedBox(height: 12),
            FutureBuilder(
              future: slotsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('No se pudieron cargar los horarios'),
                  );
                }
                final slots = snapshot.data ?? <String>[];
                if (slots.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Sin horarios disponibles'),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (_, i) => ListTile(
                    leading: const Icon(Icons.schedule),
                    title: Text(_formatSlot(slots[i])),
                    trailing: booking ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : null,
                    onTap: booking
                        ? null
                        : () async {
                            setState(() => booking = true);
                            try {
                              await _appointments.createAppointment(
                                serviceId: widget.service.id,
                                vendorId: widget.service.vendorId,
                                slot: slots[i],
                              );
                              if (mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(content: Text('Cita agendada')));
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: ${e.toString()}')),
                              );
                            } finally {
                              if (mounted) setState(() => booking = false);
                            }
                          },
                  ),
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemCount: slots.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatSlot(String slot) {
    try {
      final dt = DateTime.parse(slot).toLocal();
      final two = (int v) => v.toString().padLeft(2, '0');
      return '${dt.year}-${two(dt.month)}-${two(dt.day)} ${two(dt.hour)}:${two(dt.minute)}';
    } catch (_) {
      return slot;
    }
  }
}
