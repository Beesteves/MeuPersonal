class Exercicio {
  final String id;
  final String nome;
  final String descricao;
  final String? tipo;
  final String? video;
  final String personalId;

  Exercicio({
    required this.id,
    required this.nome,
    required this.descricao,
    this.tipo,
    this.video,
    required this.personalId,
  });

  factory Exercicio.fromMap(Map<String, dynamic> map, String id, String personalId,) {
    return Exercicio(
      id: id,
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      tipo: map['tipo'],
      video: map['video'],
      personalId: personalId,
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
