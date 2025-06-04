class Assistente {
  final String id;
  final String nome;
  final String email;
  final String chaveAcesso;
  final List<String> alunos; 

  Assistente({
    required this.id,
    required this.nome,
    required this.email,
    required this.chaveAcesso,
    required this.alunos,
  });

  factory Assistente.fromMap(Map<String, dynamic> map, String id) {
    return Assistente(
      id: id,
      nome: map['nome'],
      email: map['email'],
      chaveAcesso: map['chaveAcesso'],
      alunos: List<String>.from(map['alunos'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'chaveAcesso': chaveAcesso,
      'alunos': alunos,
    };
  }
}
