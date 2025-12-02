import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Plan BNPL', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField(
              items: const [
                DropdownMenuItem(value: '7', child: Text('Plan 7 días')),
                DropdownMenuItem(value: '15', child: Text('Plan 15 días')),
              ],
              onChanged: (_) {},
            ),
            const SizedBox(height: 12),
            const Text('Tipo de entrega', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField(
              items: const [
                DropdownMenuItem(value: 'INTERNAL', child: Text('Entrega interna')),
                DropdownMenuItem(value: 'CREFIGEX', child: Text('Entrega Crefigex')),
              ],
              onChanged: (_) {},
            ),
            TextField(decoration: const InputDecoration(labelText: 'Dirección de envío')),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/payments'),
              child: const Text('Confirmar orden'),
            ),
          ],
        ),
      ),
    );
  }
}
