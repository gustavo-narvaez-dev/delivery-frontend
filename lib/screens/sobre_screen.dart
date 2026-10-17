import 'package:flutter/material.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color laranjaGourmet = Color(0xFFD35400);
    const Color marromEscuro = Color(0xFF2C1A0F);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Sobre o App', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: laranjaGourmet,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/images/logo_chef.png', height: 100),
              const SizedBox(height: 24),
              const Text(
                'Disk Nona',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: marromEscuro),
              ),
              const SizedBox(height: 8),
              Text(
                'Versão 1.0.0',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              
              const Text(
                'Objetivo do Aplicativo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: laranjaGourmet),
              ),
              const SizedBox(height: 8),
              Text(
                'Aplicativo de delivery desenvolvido para otimizar o fluxo de pedidos de pizzaria, oferecendo uma interface intuitiva para personalização de sabores meio a meio, remoção de ingredientes e escolha de bordas recheadas.',
                style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 32),

              const Text(
                'Equipe de Desenvolvimento',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: laranjaGourmet),
              ),
              const SizedBox(height: 8),
              const Text(
                'Gustavo Antonio Narvaez da Silva',
                style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 32),

              const Text(
                'Informações Acadêmicas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: laranjaGourmet),
              ),
              const SizedBox(height: 8),
              const Text(
                'Instituição: Fatec Ribeirão Preto\n'
                'Curso: Análise e Desenvolvimento de Sistemas\n'
                'Disciplina: Eletiva Programação Para Dispositivos Móveis\n'
                'Professor: Rodrigo Plotze\n',
                style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}