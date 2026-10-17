import 'package:flutter/material.dart';
import 'cardapio_screen.dart';

class AcompanhamentoScreen extends StatelessWidget {
  const AcompanhamentoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color laranjaGourmet = Color(0xFFD35400);
    const Color marromEscuro = Color(0xFF2C1A0F);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Acompanhar Pedido', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: laranjaGourmet,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.local_pizza, size: 80, color: laranjaGourmet),
            const SizedBox(height: 24),
            const Text(
              'Pedido Recebido!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: marromEscuro),
            ),
            const SizedBox(height: 8),
            const Text(
              'A Nona já está preparando a sua pizza.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            
            _buildStatusItem(Icons.receipt_long, 'Pedido Confirmado', '10:30', true, laranjaGourmet),
            _buildDivisor(),
            _buildStatusItem(Icons.local_fire_department, 'No Forno', '10:35', true, laranjaGourmet),
            _buildDivisor(),
            _buildStatusItem(Icons.two_wheeler, 'Saiu para Entrega', '--:--', false, Colors.grey),
            _buildDivisor(),
            _buildStatusItem(Icons.home, 'Entregue', '--:--', false, Colors.grey),
            
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: laranjaGourmet,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const CardapioScreen()),
                  (route) => false,
                );
              },
              child: const Text('Voltar ao Cardápio', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(IconData icon, String title, String time, bool active, Color color) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: active ? color.withOpacity(0.2) : color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(title, style: TextStyle(fontSize: 16, fontWeight: active ? FontWeight.bold : FontWeight.normal, color: active ? Colors.black : Colors.grey)),
        ),
        Text(time, style: TextStyle(color: active ? Colors.black : Colors.grey, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDivisor() {
    return Container(
      margin: const EdgeInsets.only(left: 19, top: 4, bottom: 4),
      height: 30,
      width: 2,
      color: Colors.grey.shade300,
    );
  }
}