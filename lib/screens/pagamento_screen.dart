import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/carrinho_provider.dart';
import 'acompanhamento_screen.dart';

class PagamentoScreen extends StatefulWidget {
  final double total;
  const PagamentoScreen({super.key, required this.total});

  @override
  State<PagamentoScreen> createState() => _PagamentoScreenState();
}

class _PagamentoScreenState extends State<PagamentoScreen> {
  final _formKey = GlobalKey<FormState>();
  final Color laranjaGourmet = const Color(0xFFD35400);
  final Color marromEscuro = const Color(0xFF2C1A0F);
  
  String formaPagamento = 'No App (Cartão/Pix)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Pagamento e Entrega', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: laranjaGourmet,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total a Pagar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: marromEscuro)),
                      Text(
                        'R\$ ${widget.total.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: laranjaGourmet),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Forma de Pagamento', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: marromEscuro)),
              const SizedBox(height: 12),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    RadioListTile(
                      title: const Text('Pagar pelo App (Pix/Cartão)'),
                      activeColor: laranjaGourmet,
                      value: 'No App (Cartão/Pix)',
                      groupValue: formaPagamento,
                      onChanged: (val) => setState(() => formaPagamento = val.toString()),
                    ),
                    RadioListTile(
                      title: const Text('Pagar na Entrega (Dinheiro/Maquininha)'),
                      activeColor: laranjaGourmet,
                      value: 'Na Entrega',
                      groupValue: formaPagamento,
                      onChanged: (val) => setState(() => formaPagamento = val.toString()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Endereço de Entrega', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: marromEscuro)),
              const SizedBox(height: 12),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Rua / Avenida',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Número',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) => (value == null || value.isEmpty) ? 'Obrigatório' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Complemento',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: laranjaGourmet,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<CarrinhoProvider>().finalizarPedido();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AcompanhamentoScreen()),
                (route) => false,
              );
            }
          },
          child: const Text('Confirmar Pedido', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }
}