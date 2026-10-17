import 'package:flutter/material.dart';
import '../models/app_models.dart';

class ItemCarrinho {
  final Produto produto1;
  final Produto? produto2;
  List<String> ingredientesRemovidos1 = [];
  List<String> ingredientesRemovidos2 = [];
  String bordaSelecionada = 'Sem borda';

  ItemCarrinho({required this.produto1, this.produto2});

  double get precoBase => (produto2 == null) ? produto1.preco : (produto1.preco > produto2!.preco ? produto1.preco : produto2!.preco);
  double get precoTotal => precoBase + (bordaSelecionada != 'Sem borda' ? 10.0 : 0.0);
}

class CarrinhoProvider extends ChangeNotifier {
  final List<ItemCarrinho> _itens = [];
  bool _temPedidoAtivo = false;

  List<ItemCarrinho> get itens => _itens;
  int get quantidade => _itens.length;
  double get subtotal => _itens.fold(0, (sum, item) => sum + item.precoTotal);
  bool get temPedidoAtivo => _temPedidoAtivo;

  void adicionar(ItemCarrinho item) {
    _itens.add(item);
    notifyListeners();
  }

  void atualizarPedido() {
    notifyListeners();
  }

  void finalizarPedido() {
    _itens.clear();
    _temPedidoAtivo = true;
    notifyListeners();
  }
}