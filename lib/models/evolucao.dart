class Evolucao {
  final String id;
  final DateTime data;
  final String exercicioId;
  final double carga;

  Evolucao({
    required this.id,
    required this.data,
    required this.exercicioId,
    required this.carga,
  });

  factory Evolucao.fromMap(Map<String, dynamic> map, String id) {
    return Evolucao(
      id: id,
      data: (map['data']).toDate(),
      exercicioId: map['exercicioId'],
      carga: map['carga'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'exercicioId': exercicioId,
      'carga': carga,
    };
  }
}
