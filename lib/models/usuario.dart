import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  late String id;
  final String nome;
  final String email;
  final String tipo; // "personal", "assistente", "aluno"
  final DateTime criadoEm;
  final String? personalId; // só para assistente e aluno
  final String? assistenteId;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.tipo,
    required this.criadoEm,
    this.personalId,
    this.assistenteId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'tipo': tipo,
      'criadoEm': Timestamp.fromDate(criadoEm),
      if (personalId != null) 'personalId': personalId,
      if (assistenteId != null) 'assistenteId': assistenteId,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      tipo: map['tipo'] ?? '',
      criadoEm: map['criadoEm'] is Timestamp
          ? (map['criadoEm'] as Timestamp).toDate()
          : DateTime.tryParse(map['criadoEm'] ?? '') ?? DateTime.now(),
      personalId: map['personalId'],
      assistenteId: map['assistenteId'],
    );
  }
}
