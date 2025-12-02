import 'package:flutter/material.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagos BNPL')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Cuota 1'),
            subtitle: const Text('Vence en 7 días'),
            trailing: ElevatedButton(onPressed: () {}, child: const Text('Registrar pago')),
          ),
        ],
      ),
    );
  }
}
