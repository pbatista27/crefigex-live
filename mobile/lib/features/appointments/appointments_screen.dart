import 'package:flutter/material.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Citas')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Servicio consultoría'),
            subtitle: const Text('1 Feb 10:00 AM'),
            trailing: ElevatedButton(onPressed: () {}, child: const Text('Reprogramar')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
