 import 'package:flutter_test/flutter_test.dart';
import 'package:tcc/models/exercicio.dart';

void main() {
  group('Exercicio Model', () {
    test('fromMap e toMap devem funcionar corretamente', () {
      // Arrange
      final map = {
        'nome': 'Agachamento',
        'descricao': 'Exercício para pernas',
        'tipo': 'Força',
        'video': 'https://video.com/agachamento',
      };
      const id = 'abc123';

      // Act
      final model = Exercicio.fromMap(map, id, 'personal456');
      final resultToMap = model.toMap();

      // Assert
      expect(model.id, id);
      expect(model.nome, 'Agachamento');
      expect(resultToMap, map);
    });
  });
}
