class Metodo {
  final String id;
  final String nome;
  final String descricao;
  final String cor;
  final String personalId;

  Metodo({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.cor,
    required this.personalId,
  });

  // O personalId agora é passado como parâmetro, pois vem do caminho do documento
  factory Metodo.fromMap(Map<String, dynamic> map, String id, String personalId) {
    return Metodo(
      id: id,
      nome: map['nome'],
      descricao: map['descricao'],
      cor: map['cor'],
      personalId: personalId,
    );
  }

  // O personalId não precisa ser salvo no mapa, pois já está no caminho da subcoleção
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'cor': cor,
    };
  }
}
