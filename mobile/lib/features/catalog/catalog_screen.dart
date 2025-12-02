import 'package:flutter/material.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = List.generate(6, (i) => 'Producto ${i + 1}');
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: products.length,
        itemBuilder: (_, i) => Card(
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, '/video'),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 42),
                  const SizedBox(height: 8),
                  Text(products[i]),
                  TextButton(onPressed: () => Navigator.pushNamed(context, '/cart'), child: const Text('Agregar')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
