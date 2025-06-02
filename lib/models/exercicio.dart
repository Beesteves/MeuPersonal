class Exercicio {
  final String id;
  final String nome;
  final String descricao;
  final String tipo;
  final String video;

  Exercicio({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.tipo,
    required this.video,
  });

  factory Exercicio.fromMap(Map<String, dynamic> map, String id) {
    return Exercicio(
      id: id,
      nome: map['nome'],
      descricao: map['descricao'],
      tipo: map['tipo'],
      video: map['video'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'tipo': tipo,
      'video': video,
    };
  }
}
