import 'package:cloud_firestore/cloud_firestore.dart';

class Mensagem {
  final String id;
  final String destinatarioId;
  final String remetenteId;
  final String mensagem;
  final DateTime data;
  final String? feedbackId;

  Mensagem({
    required this.id,
    required this.destinatarioId,
    required this.remetenteId,
    required this.mensagem,
    required this.data,
    this.feedbackId,
  });

  factory Mensagem.fromMap(Map<String, dynamic> map, String id) {
    return Mensagem(
      id: id,
      destinatarioId: map['destinatarioId'],
      remetenteId: map['remetenteId'],
      mensagem: map['mensagem'],
      data: map['data'] is Timestamp    ? (map['data'] as Timestamp).toDate()    : map['data'],
      feedbackId: map['feedbackId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'destinatarioId': destinatarioId,
      'remetenteId': remetenteId,
      'mensagem': mensagem,
      'data': data,
      'feedbackId': feedbackId,
    };
  }
}
