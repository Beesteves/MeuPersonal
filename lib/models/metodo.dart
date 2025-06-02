class Metodo {
  final String id;
  final String nome;
  final String descricao;
  final String cor;

  Metodo({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.cor
  });

  factory Metodo.fromMap(Map<String, dynamic> map, String id) {
    return Metodo(
      id: id,
      nome: map['nome'],
      descricao: map['descricao'],
      cor: map['cor'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
    };
  }
}
