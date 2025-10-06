import 'package:cloud_firestore/cloud_firestore.dart';

class Evolucao {
  final String data;
  final double carga;

  Evolucao({
    required this.data,
    required this.carga,
  });

  factory Evolucao.fromMap(Map<String, dynamic> map, String id) {
    String dataString;

    // Converte Timestamp → String (ISO8601)
    if (map['data'] is Timestamp) {
      dataString = (map['data'] as Timestamp).toDate().toIso8601String();
    } else if (map['data'] is DateTime) {
      dataString = (map['data'] as DateTime).toIso8601String();
    } else {
      dataString = map['data'].toString();
    }

    return Evolucao(
      data: dataString,
      carga: (map['carga'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'carga': carga,
    };
  }
}
