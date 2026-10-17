class Estabelecimento {
  final int id;
  final String nomeFantasia;
  final String corPrimaria;
  final String urlLogo;

  Estabelecimento({
    required this.id,
    required this.nomeFantasia,
    required this.corPrimaria,
    required this.urlLogo,
  });

  factory Estabelecimento.fromJson(Map<String, dynamic> json) {
    return Estabelecimento(
      id: json['id'] ?? 0,
      nomeFantasia: json['nomeFantasia'] ?? '',
      corPrimaria: json['corPrimaria'] ?? '#8B0000',
      urlLogo: json['urlLogo'] ?? '',
    );
  }
}

class Categoria {
  final int id;
  final String nome;

  Categoria({
    required this.id,
    required this.nome,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
    );
  }
}

class Produto {
  final int id;
  final String nome;
  final String descricao;
  final double preco;
  final Categoria categoria;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.categoria,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      descricao: json['descricao'] ?? '',
      preco: (json['preco'] as num).toDouble(), 
      categoria: Categoria.fromJson(json['categoria']),
    );
  }
}