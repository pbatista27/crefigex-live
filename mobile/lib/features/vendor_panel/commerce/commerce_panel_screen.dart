import 'package:flutter/material.dart';

class CommercePanelScreen extends StatelessWidget {
  const CommercePanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      ('Productos', Icons.inventory_2_outlined),
      ('Videos', Icons.videocam),
      ('Entregas', Icons.local_shipping),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Panel Comercio')),
      body: ListView(
        children: actions
            .map((a) => ListTile(
                  leading: Icon(a.$2),
                  title: Text(a.$1),
                  onTap: () {},
                ))
            .toList(),
      ),
    );
  }
}
