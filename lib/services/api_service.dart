import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/app_models.dart';

class ApiService {
  static const String baseUrl = 'https://app-delivery-hv79.onrender.com';

  Future<List<Produto>> buscarProdutos() async {
    final response = await http.get(Uri.parse('$baseUrl/api/produtos'));

    if (response.statusCode == 200) {
      final List<dynamic> dadosJson = json.decode(utf8.decode(response.bodyBytes));
      
      return dadosJson.map((json) => Produto.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar o cardápio. O servidor está ligado?');
    }
  }
}