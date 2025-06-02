class Usuario {
  final String id;
  final String nome;
  final String email;
  final String tipo;

  Usuario({
    required this.id, required this.nome, required this.email, required this.tipo,
  });

  factory Usuario.fromMap(Map<String, dynamic> map, String id) {
    return Usuario(
      id: id,
      nome: map['nome'],
      email: map['email'],
      tipo: map['tipo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'tipo': tipo,
    };
  }
}
