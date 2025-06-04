class Aluno {
  final String id;
  final String nome;
  final String email;
  final String? assistenteId;
  final String? chaveAcesso;
  final List<String>? treinoId;

  Aluno({
    required this.id,
    required this.nome,
    required this.email,
    this.assistenteId,
    this.chaveAcesso,
    this.treinoId,
  });

  factory Aluno.fromMap(Map<String, dynamic> map, String id) {
    return Aluno(
      id: id,
      nome: map['nome'],
      email: map['email'],
      assistenteId: map['assistenteId'],
      chaveAcesso: map['chaveAcesso'],
      treinoId: List<String>.from(map['treinoId'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'assistenteId': assistenteId,
      'chaveAcesso': chaveAcesso,
      'treinoId': treinoId,
    };
  }
}
