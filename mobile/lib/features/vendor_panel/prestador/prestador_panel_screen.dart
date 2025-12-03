import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/state/user_state.dart';

class PrestadorPanelScreen extends StatelessWidget {
  const PrestadorPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserState>(context);
    if (user.userId == null) {
      return const Scaffold(body: Center(child: Text('Inicia sesión como prestador de servicio')));
    }
    if (!user.roles.contains('VENDEDOR') || user.vendorType != 'PRESTADOR_SERVICIO') {
      return const Scaffold(body: Center(child: Text('Panel solo para prestadores de servicio')));
    }
    final actions = [
      PanelAction('Servicios', Icons.handshake_outlined, 'Crea y gestiona tus servicios'),
      PanelAction('Agenda', Icons.calendar_today, 'Define horarios y disponibilidad'),
      PanelAction('Videos', Icons.videocam, 'Comparte lives y contenido'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Panel Prestador')),
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
  PanelAction(this.title, this.icon, this.subtitle);
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
              color: const Color(0xFF10B981).withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(action.icon, color: const Color(0xFF10B981)),
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
          const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF94A3B8))
        ],
      ),
    );
  }
}
