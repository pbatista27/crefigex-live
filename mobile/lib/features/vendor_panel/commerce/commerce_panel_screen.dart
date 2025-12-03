import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/state/user_state.dart';

class CommercePanelScreen extends StatelessWidget {
  const CommercePanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserState>(context);
    if (user.userId == null) {
      return const Scaffold(body: Center(child: Text('Inicia sesión como vendedor comercio')));
    }
    if (!user.roles.contains('VENDEDOR') || user.vendorType != 'COMERCIO') {
      return const Scaffold(body: Center(child: Text('Panel solo para vendedores COMERCIO')));
    }
    final actions = [
      PanelAction('Productos', Icons.inventory_2_outlined, 'Gestiona catálogo, precios y stock', route: null),
      PanelAction('Videos', Icons.videocam, 'Sube lives y conecta con clientes', route: null),
      PanelAction('Entregas', Icons.local_shipping, 'Controla estados y fotos de entrega', route: '/vendor/commerce/deliveries'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Panel Comercio')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: actions.length,
        itemBuilder: (_, i) => _PanelCard(action: actions[i]),
      ),
    );
  }
}

class PanelAction {
  final String title;
  final IconData icon;
  final String subtitle;
  final String? route;
  PanelAction(this.title, this.icon, this.subtitle, {this.route});
}

class _PanelCard extends StatelessWidget {
  final PanelAction action;
  const _PanelCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF6366f1).withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(action.icon, color: const Color(0xFF6366f1)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(action.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(action.subtitle, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
              ],
            ),
          ),
          InkWell(
            onTap: action.route != null ? () => Navigator.pushNamed(context, action.route!) : null,
            child: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF94A3B8)),
          )
        ],
      ),
    );
  }
}
