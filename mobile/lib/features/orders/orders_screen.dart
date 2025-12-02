import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis pedidos')),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (_, i) => ListTile(
          title: Text('Orden ${i + 1}'),
          subtitle: const Text('BNPL en curso'),
          trailing: TextButton(
            onPressed: () => Navigator.pushNamed(context, '/deliveries'),
            child: const Text('Ver entrega'),
          ),
        ),
      ),
    );
  }
}
