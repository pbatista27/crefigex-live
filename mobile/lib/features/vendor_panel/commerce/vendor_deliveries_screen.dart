import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/delivery_service.dart';

class VendorDeliveriesScreen extends StatefulWidget {
  const VendorDeliveriesScreen({super.key});

  @override
  State<VendorDeliveriesScreen> createState() => _VendorDeliveriesScreenState();
}

class _VendorDeliveriesScreenState extends State<VendorDeliveriesScreen> {
  final _deliveryService = DeliveryService();
  late Future<List<DeliveryDto>> _future;

  @override
  void initState() {
    super.initState();
    _future = _deliveryService.listVendor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entregas del comercio')),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('No se pudieron cargar las entregas'));
          }
          final deliveries = snapshot.data ?? <DeliveryDto>[];
          if (deliveries.isEmpty) return const Center(child: Text('Sin entregas'));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: deliveries.length,
            itemBuilder: (_, i) => _DeliveryItem(data: deliveries[i], onUpdated: _refresh),
          );
        },
      ),
    );
  }

  void _refresh() {
    setState(() {
      _future = _deliveryService.listVendor();
    });
  }
}

class _DeliveryItem extends StatelessWidget {
  final DeliveryDto data;
  final VoidCallback onUpdated;
  const _DeliveryItem({required this.data, required this.onUpdated});

  @override
  Widget build(BuildContext context) {
    final isInternal = data.deliveryType == 'INTERNAL';
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
          Text('Orden ${data.orderId}', style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Tipo: ${data.deliveryType} · Estado: ${data.status}', style: const TextStyle(color: Color(0xFF64748B))),
          if (data.photoUrl != null && data.photoUrl!.isNotEmpty) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(data.photoUrl!, height: 120, width: double.infinity, fit: BoxFit.cover),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              if (isInternal)
                TextButton(
                  onPressed: () => _changeStatus(context, data.id),
                  child: const Text('Cambiar estado'),
                ),
              const Spacer(),
              if (isInternal)
                ElevatedButton.icon(
                  onPressed: () => _markDelivered(context, data.id),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text('Entregado con foto'),
                ),
            ],
          )
        ],
      ),
    );
  }

  void _changeStatus(BuildContext context, String id) async {
    final status = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Estado interno'),
        children: [
          ...['WAITING_PAYMENT_APPROVAL', 'PENDING_DELIVERY', 'IN_DELIVERY', 'DELIVERED']
              .map((s) => SimpleDialogOption(
                    onPressed: () => Navigator.pop(ctx, s),
                    child: Text(s),
                  ))
        ],
      ),
    );
    if (status == null) return;
    try {
      await DeliveryService().updateStatus(id, status);
      onUpdated();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void _markDelivered(BuildContext context, String id) async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Galería'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Cámara'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final picked = await picker.pickImage(source: source, imageQuality: 75);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    final dataUrl = 'data:${picked.mimeType ?? 'image/jpeg'};base64,${base64Encode(bytes)}';
    try {
      await DeliveryService().markDelivered(id, photoUrl: dataUrl);
      onUpdated();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Entrega marcada con foto')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }
}
