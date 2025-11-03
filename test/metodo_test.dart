import 'package:flutter_test/flutter_test.dart';
import 'package:tcc/models/metodo.dart';

void main() {
  group('Metodo Model', () {
    test('fromMap e toMap devem funcionar corretamente', () {
      // Arrange
      final map = {
        'nome': 'Drop-set',
        'descricao': 'Realizar até a falha e diminuir o peso.',
        'cor': '#FF5733',
      };
      const id = 'metodo123';
      const personalId = 'personal456';

      // Act
      final metodo = Metodo.fromMap(map, id, personalId);
      final resultToMap = metodo.toMap();

      // Assert
      expect(resultToMap, map);
    });
  });
}