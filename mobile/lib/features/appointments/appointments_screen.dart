import 'package:flutter/material.dart';
import '../../core/data/sample_data.dart';
import '../../core/services/appointment_service.dart';
import '../../core/state/user_state.dart';
import 'package:provider/provider.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserState>(context, listen: false);
    if (user.userId == null) {
      return const Scaffold(body: Center(child: Text('Inicia sesión para ver citas')));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Citas')),
      body: FutureBuilder(
        future: AppointmentService().listMine(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('No hay citas'));
          }
          final appointments = snapshot.data ?? [];
          if (appointments.isEmpty) return const Center(child: Text('No hay citas'));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (_, i) => _AppointmentCard(data: appointments[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF6366f1),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final dynamic data; // SampleAppointment o AppointmentDto
  const _AppointmentCard({required this.data});

  @override
  Widget build(BuildContext context) {
    Color bg = const Color(0xFFFEF3C7);
    Color fg = const Color(0xFFF59E0B);
    if (data.status.toUpperCase().contains('CONFIRMED')) {
      bg = const Color(0xFFDCFCE7);
      fg = const Color(0xFF16A34A);
    }
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
            child: const Icon(Icons.event_available, color: Color(0xFF6366f1)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data is SampleAppointment ? data.serviceName : 'Servicio', style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(data is SampleAppointment ? data.vendor : data.vendorId, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                Text(data is SampleAppointment ? data.date : data.scheduledAt, style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
            child: Text(data.status, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
