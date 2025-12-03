import 'package:flutter/material.dart';
import '../../core/data/sample_data.dart';
import '../../core/services/payment_service.dart';
import '../../core/state/user_state.dart';
import 'package:provider/provider.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserState>(context, listen: false);
    if (user.userId == null) {
      return const Scaffold(body: Center(child: Text('Inicia sesión para ver pagos')));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Pagos BNPL')),
      body: FutureBuilder(
        future: PaymentService().listMyInstallments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('No hay cuotas'));
          }
          final installments = snapshot.data ?? [];
          if (installments.isEmpty) return const Center(child: Text('No hay cuotas'));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: installments.length,
            itemBuilder: (_, i) => _PaymentCard(data: installments[i]),
          );
        },
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final dynamic data; // SampleInstallment o InstallmentDto
  const _PaymentCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final amount = data is SampleInstallment ? data.amount : data.amount;
    final orderId = data is SampleInstallment ? data.orderId : data.orderId;
    final dueDate = data is SampleInstallment ? data.dueDate : data.dueDate;
    final paid = data is SampleInstallment ? data.paid : data.paid;
    final refCtrl = TextEditingController();
    final bankOrigin = TextEditingController();
    final bankDest = TextEditingController();
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
            child: const Icon(Icons.payments, color: Color(0xFF6366f1)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Orden $orderId', style: const TextStyle(fontWeight: FontWeight.w700)),
                Text('Vence: $dueDate', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                Text('\$$amount', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                if (!paid) ...[
                  TextField(
                    controller: refCtrl,
                    decoration: const InputDecoration(labelText: 'Referencia', isDense: true),
                  ),
                  TextField(
                    controller: bankOrigin,
                    decoration: const InputDecoration(labelText: 'Banco origen', isDense: true),
                  ),
                  TextField(
                    controller: bankDest,
                    decoration: const InputDecoration(labelText: 'Banco destino', isDense: true),
                  ),
                ],
              ],
            ),
          ),
          ElevatedButton(
            onPressed: paid
                ? null
                : () async {
                    try {
                      await PaymentService().registerPayment(
                        orderId: orderId,
                        installmentId: data is SampleInstallment ? data.id : data.id,
                        amount: amount,
                        method: 'TRANSFERENCIA',
                        reference: refCtrl.text,
                        bankOrigin: bankOrigin.text,
                        bankDest: bankDest.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pago registrado')));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(paid ? 'Pagada' : 'Registrar'),
          )
        ],
      ),
    );
  }
}
