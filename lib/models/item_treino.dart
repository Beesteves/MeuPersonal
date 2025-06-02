class ItemTreino {
  final String exercicioId;
  final String metodoId;
  final int numSerie;
  final int numRepeticao;

  ItemTreino({
    required this.exercicioId,
    required this.metodoId,
    required this.numSerie,
    required this.numRepeticao,
  });

  factory ItemTreino.fromMap(Map<String, dynamic> map) {
    return ItemTreino(
      exercicioId: map['exercicioId'],
      metodoId: map['metodoId'],
      numSerie: map['numSerie'],
      numRepeticao: map['numRepeticao'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exercicioId': exercicioId,
      'metodoId': metodoId,
      'numSerie': numSerie,
      'numRepeticao': numRepeticao,
    };
  }
}
