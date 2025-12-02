import 'package:flutter/material.dart';

class PrestadorPanelScreen extends StatelessWidget {
  const PrestadorPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = [
      ('Servicios', Icons.handshake_outlined),
      ('Agenda', Icons.calendar_today),
      ('Videos', Icons.videocam),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Panel Prestador')),
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
