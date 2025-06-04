class Personal {
  final String id;
  
  final String nome;
  final String email;

  Personal({
    required this.id,
    required this.nome,
    required this.email,
  });

  factory Personal.fromMap(Map<String, dynamic> map, String id) {
    return Personal(
      id: id,
      nome: map['nome'],
      email: map['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
    };
  }
}
