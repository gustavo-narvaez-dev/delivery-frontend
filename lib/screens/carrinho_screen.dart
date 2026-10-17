import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pagamento_screen.dart';
import '../providers/carrinho_provider.dart';

class CarrinhoScreen extends StatefulWidget {
  const CarrinhoScreen({super.key});

  @override
  State<CarrinhoScreen> createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  final Color laranjaGourmet = const Color(0xFFD35400);
  final Color marromEscuro = const Color(0xFF2C1A0F);

  final List<String> opcoesBorda = ['Sem borda', 'Cheddar', 'Catupiry', 'Cream Cheese', 'Mussarela'];
  final double taxaEntrega = 5.00;

  @override
  Widget build(BuildContext context) {
    final carrinho = context.watch<CarrinhoProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Seu Pedido', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: laranjaGourmet,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: carrinho.itens.isEmpty 
        ? const Center(child: Text('Seu carrinho está vazio', style: TextStyle(fontSize: 18, color: Colors.grey)))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: carrinho.itens.length,
            itemBuilder: (context, index) {
              final item = carrinho.itens[index];
              final isMeioAMeio = item.produto2 != null;
              
              final tituloPizza = isMeioAMeio 
                ? '1/2 ${item.produto1.nome} e 1/2 ${item.produto2!.nome}'
                : item.produto1.nome;

              final ing1 = item.produto1.descricao.split(RegExp(r',\s*|\s+e\s+')).where((i) => i.trim().isNotEmpty).toList();
              final ing2 = isMeioAMeio ? item.produto2!.descricao.split(RegExp(r',\s*|\s+e\s+')).where((i) => i.trim().isNotEmpty).toList() : [];

              return Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tituloPizza, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: marromEscuro)),
                      const SizedBox(height: 16),
                      
                      Text('Remover ingredientes:', style: TextStyle(fontWeight: FontWeight.bold, color: marromEscuro)),
                      const SizedBox(height: 8),
                      
                      if (isMeioAMeio) Text('Da metade ${item.produto1.nome}:', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                      Wrap(
                        spacing: 8,
                        children: ing1.map((ingrediente) {
                          final removido = item.ingredientesRemovidos1.contains(ingrediente);
                          return FilterChip(
                            label: Text(
                              ingrediente,
                              style: TextStyle(decoration: removido ? TextDecoration.lineThrough : null, color: removido ? Colors.white : marromEscuro),
                            ),
                            selected: removido,
                            selectedColor: Colors.red.shade400,
                            backgroundColor: Colors.grey.shade200,
                            checkmarkColor: Colors.white,
                            onSelected: (bool selected) {
                              selected ? item.ingredientesRemovidos1.add(ingrediente) : item.ingredientesRemovidos1.remove(ingrediente);
                              carrinho.atualizarPedido(); // AVISA O PROVIDER
                            },
                          );
                        }).toList(),
                      ),

                      if (isMeioAMeio) ...[
                        const SizedBox(height: 12),
                        Text('Da metade ${item.produto2!.nome}:', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                        Wrap(
                          spacing: 8,
                          children: ing2.map((ingrediente) {
                            final removido = item.ingredientesRemovidos2.contains(ingrediente);
                            return FilterChip(
                              label: Text(
                                ingrediente,
                                style: TextStyle(decoration: removido ? TextDecoration.lineThrough : null, color: removido ? Colors.white : marromEscuro),
                              ),
                              selected: removido,
                              selectedColor: Colors.red.shade400,
                              backgroundColor: Colors.grey.shade200,
                              checkmarkColor: Colors.white,
                              onSelected: (bool selected) {
                                selected ? item.ingredientesRemovidos2.add(ingrediente) : item.ingredientesRemovidos2.remove(ingrediente);
                                carrinho.atualizarPedido(); // AVISA O PROVIDER
                              },
                            );
                          }).toList(),
                        ),
                      ],
                      
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      Text('Adicionar bordas recheadas (+ R\$ 10,00):', style: TextStyle(fontWeight: FontWeight.bold, color: marromEscuro)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: item.bordaSelecionada,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: opcoesBorda.map((borda) => DropdownMenuItem(value: borda, child: Text(borda))).toList(),
                        onChanged: (val) {
                          item.bordaSelecionada = val!;
                          carrinho.atualizarPedido(); // AVISA O PROVIDER
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Subtotal do item: R\$ ${item.precoTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: laranjaGourmet),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
      bottomNavigationBar: carrinho.itens.isEmpty ? null : Container(
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PagamentoScreen(total: carrinho.subtotal + taxaEntrega)),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Ir para pagamento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(
                'R\$ ${(carrinho.subtotal + taxaEntrega).toStringAsFixed(2).replaceAll('.', ',')}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}