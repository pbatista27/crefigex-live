import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Producto 1'),
            subtitle: const Text('Plan BNPL 7 días'),
            trailing: const Text('\$25'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/checkout'),
            child: const Text('Proceder al checkout'),
          ),
        ],
      ),
    );
  }
}
