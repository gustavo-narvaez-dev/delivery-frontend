import 'package:flutter/material.dart';
import 'cardapio_screen.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController(); // Novo controlador para o telefone
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  final Color laranjaGourmet = const Color(0xFFD35400);
  final Color marromEscuro = const Color(0xFF2C1A0F);

  void _realizarCadastro() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Conta criada com sucesso! Bem-vindo à Disk Nona.'),
          backgroundColor: Colors.green.shade700,
        ),
      );
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const CardapioScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  String? _validarEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Por favor, informe o seu e-mail.';
    final regexEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!regexEmail.hasMatch(value)) return 'Por favor, informe um e-mail válido com formato correto.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Cadastro de Usuário', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: laranjaGourmet,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/images/logo_chef.png', height: 80),
                  const SizedBox(height: 24),
                  Text(
                    'Crie sua conta',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: marromEscuro),
                  ),
                  const SizedBox(height: 32),

                  // Nome do usuário
                  TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      labelText: 'Nome Completo',
                      prefixIcon: Icon(Icons.person_outline, color: laranjaGourmet),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Informe o seu nome completo.' : null,
                  ),
                  const SizedBox(height: 16),

                  // E-mail
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email_outlined, color: laranjaGourmet),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: _validarEmail,
                  ),
                  const SizedBox(height: 16),

                  // Número de telefone
                  TextFormField(
                    controller: _telefoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Número de Telefone',
                      prefixIcon: Icon(Icons.phone_outlined, color: laranjaGourmet),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) => (value == null || value.trim().isEmpty) ? 'Informe o seu número de telefone.' : null,
                  ),
                  const SizedBox(height: 16),

                  // Senha
                  TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock_outline, color: laranjaGourmet),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) => (value == null || value.isEmpty) ? 'Informe uma senha.' : null,
                  ),
                  const SizedBox(height: 16),

                  // Confirmação de senha
                  TextFormField(
                    controller: _confirmarSenhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirmação de Senha',
                      prefixIcon: Icon(Icons.lock_reset, color: laranjaGourmet),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Confirme a sua senha.';
                      if (value != _senhaController.text) return 'As senhas não coincidem. Tente novamente.';
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Botão de Confirmação
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: laranjaGourmet,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _realizarCadastro,
                    child: const Text('Criar conta', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}