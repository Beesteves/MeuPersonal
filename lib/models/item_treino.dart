class ItemTreino {
  final String? id;
  final String exercicioId;
  final String metodoId;
  final int numSerie;
  final int numRepeticao;

  ItemTreino({
    this.id,
    required this.exercicioId,
    required this.metodoId,
    required this.numSerie,
    required this.numRepeticao,
  });

  factory ItemTreino.fromMap(Map<String, dynamic> map, String id) {
    return ItemTreino(
      id: id,
      exercicioId: map['exercicioId'],
      metodoId: map['metodoId'],
      numSerie: map['numSerie'],
      numRepeticao: map['numRepeticao'],
    );
  }

  Map<String, dynamic> toMap() {
  return {
    'id': id,
    'exercicioId': exercicioId,
    'metodoId': metodoId,
    'numSerie': numSerie,
    'numRepeticao': numRepeticao,
  };
}
}
