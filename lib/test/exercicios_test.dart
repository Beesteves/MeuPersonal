 import 'package:flutter_test/flutter_test.dart';
import 'package:tcc/models/exercicio.dart';

void main() {
  group('ExercicioModel', () {
    test('fromMap e toMap devem funcionar corretamente', () {
      final map = {
        'nome': 'Agachamento',
        'descricao': 'Exercício para pernas',
        'tipo': 'Força',
        'video': 'https://video.com/agachamento'
      };

      final model = Exercicio.fromMap(map, 'abc123', 'personalId');

      expect(model.id, 'abc123');
      expect(model.nome, 'Agachamento');
      expect(model.toMap(), map);
    });
  });
}
