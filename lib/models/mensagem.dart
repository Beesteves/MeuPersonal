import 'package:cloud_firestore/cloud_firestore.dart';

class Mensagem {
//  final String id;
//  final String destinatarioId;
  final String remetenteId;
  final String texto;
  final DateTime timestamp;
  final String tipo;

  Mensagem({
    // required this.id,
    // required this.destinatarioId,
    required this.remetenteId,
    required this.texto,
    required this.timestamp,
    this.tipo = 'mensage',
  });

  factory Mensagem.fromMap(Map<String, dynamic> map, String id) {
    return Mensagem(
      // id: id,
      // destinatarioId: map['destinatarioId'],
      remetenteId: map['remetenteId'],
      texto: map['texto'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      tipo: map['tipo'] ?? 'mensagem',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'destinatarioId': destinatarioId,
      'remetenteId': remetenteId,
      'texto': texto,
      'timestamp': timestamp,
      'tipo': tipo,
    };
  }
}
