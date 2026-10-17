import 'package:flutter/material.dart';

class HistoricoPedidosScreen extends StatelessWidget {
  const HistoricoPedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color laranjaGourmet = Color(0xFFD35400);
    const Color marromEscuro = Color(0xFF2C1A0F);

    final List<Map<String, dynamic>> pedidos = [
      {'id': '#1045', 'data': '14/10/2026', 'valor': 'R\$ 95,00', 'status': 'Entregue'},
      {'id': '#0982', 'data': '02/10/2026', 'valor': 'R\$ 120,50', 'status': 'Entregue'},
      {'id': '#0850', 'data': '15/09/2026', 'valor': 'R\$ 65,00', 'status': 'Cancelado'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Histórico de Pedidos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: laranjaGourmet,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pedidos.length,
        itemBuilder: (context, index) {
          final pedido = pedidos[index];
          final isCancelado = pedido['status'] == 'Cancelado';

          return Card(
            color: Colors.white,
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: isCancelado ? Colors.red.shade100 : Colors.green.shade100,
                child: Icon(
                  isCancelado ? Icons.cancel_outlined : Icons.check_circle_outline,
                  color: isCancelado ? Colors.red : Colors.green,
                ),
              ),
              title: Text('Pedido ${pedido['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text('${pedido['data']} • ${pedido['status']}'),
              trailing: Text(
                pedido['valor'],
                style: const TextStyle(fontWeight: FontWeight.w900, color: marromEscuro, fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}