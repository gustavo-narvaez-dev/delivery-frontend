import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/usuario_provider.dart';
import '../providers/carrinho_provider.dart';
import 'historico_pedidos_screen.dart';
import 'acompanhamento_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _emailController;

  final Color laranjaGourmet = const Color(0xFFD35400);
  final Color marromEscuro = const Color(0xFF2C1A0F);

  @override
  void initState() {
    super.initState();
    final usuario = context.read<UsuarioProvider>();
    _nomeController = TextEditingController(text: usuario.nome);
    _emailController = TextEditingController(text: usuario.email);
  }

  void _salvarAlteracoes() {
    if (_formKey.currentState!.validate()) {
      context.read<UsuarioProvider>().atualizarNome(_nomeController.text);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Perfil atualizado com sucesso!'),
          backgroundColor: Colors.green.shade700,
        ),
      );
      Navigator.pop(context);
    }
  }

  void _mostrarSeletorDeFoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Escolha um Avatar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: marromEscuro),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildOpcaoFoto('https://api.dicebear.com/8.x/avataaars/png?seed=Felix&backgroundColor=b6e3f4'),
                _buildOpcaoFoto('https://api.dicebear.com/8.x/avataaars/png?seed=Ane&backgroundColor=ffdfbf'),
                _buildOpcaoFoto('https://api.dicebear.com/8.x/avataaars/png?seed=Leo&backgroundColor=c0aede'),
                _buildOpcaoFoto('https://api.dicebear.com/8.x/avataaars/png?seed=Liliana&backgroundColor=ffdfbf'),
                _buildOpcaoFoto('https://api.dicebear.com/8.x/avataaars/png?seed=Jack&backgroundColor=d1d4f9'),
                _buildOpcaoFoto('https://api.dicebear.com/8.x/avataaars/png?seed=Jocelyn&backgroundColor=b6e3f4'),
                _buildOpcaoFoto(''),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcaoFoto(String url) {
    return GestureDetector(
      onTap: () {
        context.read<UsuarioProvider>().atualizarFoto(url);
        Navigator.pop(context);
      },
      child: CircleAvatar(
        radius: 35,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
        child: url.isEmpty ? const Icon(Icons.person_off, color: Colors.grey, size: 30) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<UsuarioProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Meu Perfil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: laranjaGourmet,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _mostrarSeletorDeFoto,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: laranjaGourmet.withOpacity(0.2),
                          backgroundImage: usuario.fotoPerfil.isNotEmpty ? NetworkImage(usuario.fotoPerfil) : null,
                          child: usuario.fotoPerfil.isEmpty ? Icon(Icons.person, size: 50, color: laranjaGourmet) : null,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Color(0xFFD35400), shape: BoxShape.circle),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome do Usuário',
                    prefixIcon: Icon(Icons.person_outline, color: laranjaGourmet),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'O campo Nome é obrigatório.';
                    }
                    if (value.trim().length < 3) {
                      return 'O nome deve ter no mínimo 3 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _emailController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                  ),
                ),
                const SizedBox(height: 32),
                
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: laranjaGourmet,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _salvarAlteracoes,
                  child: const Text('Salvar Alterações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const SizedBox(height: 16),
                
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: laranjaGourmet),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: Icon(Icons.delivery_dining, color: laranjaGourmet),
                  onPressed: () {
                    if (context.read<CarrinhoProvider>().temPedidoAtivo) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AcompanhamentoScreen()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Nenhum pedido em andamento no momento.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  label: Text('Acompanhar Pedido Atual', style: TextStyle(color: laranjaGourmet, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),

                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: laranjaGourmet),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: Icon(Icons.history, color: laranjaGourmet),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoricoPedidosScreen()));
                  },
                  label: Text('Ver Histórico de Pedidos', style: TextStyle(color: laranjaGourmet, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar', style: TextStyle(fontSize: 16, color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}