class Assistente {
  final String id;
  final String usuarioId;
  final String chaveAcesso;
  final List<String> alunos; 

  Assistente({
    required this.id,
    required this.usuarioId,
    required this.chaveAcesso,
    required this.alunos,
  });

  factory Assistente.fromMap(Map<String, dynamic> map, String id) {
    return Assistente(
      id: id,
      usuarioId: map['usuarioId'],
      chaveAcesso: map['chaveAcesso'],
      alunos: List<String>.from(map['alunos'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
      'chaveAcesso': chaveAcesso,
      'alunos': alunos,
    };
  }
}
