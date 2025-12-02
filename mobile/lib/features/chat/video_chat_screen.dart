import 'package:flutter/material.dart';

class VideoChatScreen extends StatelessWidget {
  const VideoChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat del video')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (_, i) => ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text('Usuario $i'),
                subtitle: const Text('Mensaje en tiempo real'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(decoration: const InputDecoration(hintText: 'Escribe un mensaje'))),
                IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
