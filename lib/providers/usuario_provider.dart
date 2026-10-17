import 'package:flutter/material.dart';

class UsuarioProvider extends ChangeNotifier {
  String _nome = 'Gustavo Narvaez';
  String _email = 'gustavo@teste.com';
  String _fotoPerfil = '';

  String get nome => _nome;
  String get email => _email;
  String get fotoPerfil => _fotoPerfil;

  void atualizarNome(String novoNome) {
    _nome = novoNome;
    notifyListeners();
  }

  void atualizarFoto(String novaFoto) {
    _fotoPerfil = novaFoto;
    notifyListeners();
  }
}