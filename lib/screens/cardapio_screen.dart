import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'carrinho_screen.dart';
import 'perfil_screen.dart';
import '../models/app_models.dart';
import '../services/api_service.dart';
import '../providers/carrinho_provider.dart';
import '../providers/usuario_provider.dart';

class CardapioScreen extends StatefulWidget {
  const CardapioScreen({super.key});

  @override
  State<CardapioScreen> createState() => _CardapioScreenState();
}

class _CardapioScreenState extends State<CardapioScreen> {
  String categoriaSelecionada = 'Especiais';
  String textoBusca = '';

  final List<String> categorias = ['Especiais', 'Doces'];
  List<Produto> produtos = [];
  bool isLoading = true;
  final ApiService _apiService = ApiService();

  Produto? primeiraMetade;

  final Color laranjaGourmet = const Color(0xFFD35400);
  final Color marromEscuro = const Color(0xFF2C1A0F);
  final Color fundoBotao = const Color(0xFFFDF2E9);

  @override
  void initState() {
    super.initState();
    _carregarCardapio();
  }

  Future<void> _carregarCardapio() async {
    try {
      final dados = await _apiService.buscarProdutos();
      setState(() {
        produtos = dados;
        isLoading = false;
      });
    } catch (e) {
      setState(() { isLoading = false; });
      debugPrint('Erro na API: $e');
    }
  }

  void _selecionarMeia(Produto produto) {
    if (primeiraMetade == null) {
      setState(() { primeiraMetade = produto; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${produto.nome} selecionada. Escolha a 2ª metade!')),
      );
    } else {
      if (primeiraMetade!.categoria.nome != produto.categoria.nome) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não é possível misturar categorias diferentes.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      context.read<CarrinhoProvider>().adicionar(
        ItemCarrinho(produto1: primeiraMetade!, produto2: produto)
      );

      setState(() {
        primeiraMetade = null; 
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pizza Meio a Meio adicionada com sucesso!'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final produtosExibidos = produtos.where((p) {
      final matchCategoria = p.categoria.nome == categoriaSelecionada;
      final matchBusca = p.nome.toLowerCase().contains(textoBusca);
      return matchCategoria && matchBusca;
    }).toList();

    final usuario = context.watch<UsuarioProvider>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: laranjaGourmet,
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const PerfilScreen()));
                          },
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white24,
                            backgroundImage: usuario.fotoPerfil.isNotEmpty ? NetworkImage(usuario.fotoPerfil) : null,
                            child: usuario.fotoPerfil.isEmpty ? const Icon(Icons.person, color: Colors.white, size: 28) : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Olá, ${usuario.nome}',
                                style: const TextStyle(fontSize: 14, color: Colors.white70),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Text(
                                'Disk Nona',
                                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined, size: 28, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const CarrinhoScreen())
                          );
                        },
                      ),
                      if (context.watch<CarrinhoProvider>().quantidade > 0)
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Text(
                            '${context.watch<CarrinhoProvider>().quantidade}',
                            style: TextStyle(color: laranjaGourmet, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],  
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                onChanged: (valor) => setState(() => textoBusca = valor.toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Pesquisar pizza...',
                  prefixIcon: Icon(Icons.search, color: laranjaGourmet),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black12, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: laranjaGourmet, width: 1.5),
                  ),
                ),
              ),
            ),

            Container(
              height: 60,
              margin: const EdgeInsets.only(top: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final isSelected = categorias[index] == categoriaSelecionada;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(
                        categorias[index],
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : marromEscuro,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: laranjaGourmet,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      side: BorderSide(color: isSelected ? laranjaGourmet : Colors.black12),
                      onSelected: (bool selected) {
                        setState(() { categoriaSelecionada = categorias[index]; });
                      },
                    ),
                  );
                },
              ),
            ),

            if (primeiraMetade != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: laranjaGourmet.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: laranjaGourmet, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Escolha a outra metade para completar com ${primeiraMetade!.nome}',
                        style: TextStyle(color: laranjaGourmet, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

            Expanded(
              child: isLoading 
                ? Center(child: CircularProgressIndicator(color: laranjaGourmet))
                : produtosExibidos.isEmpty
                  ? const Center(child: Text('Nenhuma pizza encontrada.', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: produtosExibidos.length,
                      itemBuilder: (context, index) {
                        final produto = produtosExibidos[index];
                        final isPrimeiraMetade = primeiraMetade?.id == produto.id;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=200&q=80',
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        produto.nome,
                                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: marromEscuro),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        produto.descricao,
                                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.3),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'R\$ ${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: laranjaGourmet),
                                          ),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (isPrimeiraMetade) {
                                                    setState(() { primeiraMetade = null; }); 
                                                  } else {
                                                    _selecionarMeia(produto);
                                                  }
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: isPrimeiraMetade ? laranjaGourmet : Colors.white,
                                                    border: Border.all(color: laranjaGourmet),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Text(
                                                    isPrimeiraMetade ? 'Cancelar' : 'Meia',
                                                    style: TextStyle(color: isPrimeiraMetade ? Colors.white : laranjaGourmet, fontWeight: FontWeight.bold, fontSize: 13),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              InkWell(
                                                onTap: () { 
                                                  context.read<CarrinhoProvider>().adicionar(ItemCarrinho(produto1: produto));
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('${produto.nome} adicionada!')),
                                                  );
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: fundoBotao,
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Text(
                                                    'Inteira',
                                                    style: TextStyle(color: laranjaGourmet, fontWeight: FontWeight.bold, fontSize: 13),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}