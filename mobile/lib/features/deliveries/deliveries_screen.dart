import 'package:flutter/material.dart';

class DeliveriesScreen extends StatelessWidget {
  const DeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis entregas')),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (_, i) => ListTile(
          title: Text('Entrega ${i + 1}'),
          subtitle: const Text('INTERNAL - PENDING_DELIVERY'),
          trailing: ElevatedButton(onPressed: () {}, child: const Text('Confirmar')),
        ),
      ),
    );
  }
}
