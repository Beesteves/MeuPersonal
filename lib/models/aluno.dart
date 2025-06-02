class Aluno {
  final String id;
  final String usuarioId;
  final String assistenteId;
  final String chaveAcesso;
  final List<String> treinoId;

  Aluno({
    required this.id,
    required this.usuarioId,
    required this.assistenteId,
    required this.chaveAcesso,
    required this.treinoId,
  });

  factory Aluno.fromMap(Map<String, dynamic> map, String id) {
    return Aluno(
      id: id,
      usuarioId: map['usuarioId'],
      assistenteId: map['assistenteId'],
      chaveAcesso: map['chaveAcesso'],
      treinoId: List<String>.from(map['treinoId'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
      'assistenteId': assistenteId,
      'chaveAcesso': chaveAcesso,
      'treinoId': treinoId,
    };
  }
}
