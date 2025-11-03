import 'package:flutter_test/flutter_test.dart';
import 'package:tcc/models/item_treino.dart';
import 'package:tcc/models/treino.dart';

void main() {
  group('Treino e ItemTreino Models', () {
    test('ItemTreino fromMap e toMap devem funcionar corretamente', () {
      // Arrange
      final map = {
        'id': 'item01',
        'exercicioId': 'ex01',
        'metodoId': 'met01',
        'numSerie': 4,
        'numRepeticao': 12,
      };

      // Act
      final item = ItemTreino.fromMap(map, 'item01');
      final resultToMap = item.toMap();

      // Assert
      expect(item.exercicioId, 'ex01');
      expect(resultToMap, map);
    });

    test('Treino fromMap e toMap devem funcionar corretamente', () {
      // Arrange
      final itemTreino = ItemTreino(
        id: 'item01',
        exercicioId: 'ex01',
        metodoId: 'met01',
        numSerie: 4,
        numRepeticao: 12,
      );

      final map = {
        'nome': 'Treino A - Peito e Tríceps',
        'duracao': 4,
        'personalId': 'personal456',
        'status': 'ativo',
        'feitos': 0,
        'itens': [itemTreino.toMap()],
        'data': null,
        //'status': 'Ativo',
      };
      const id = 'treino123';

      // Act
      final treino = Treino.fromMap(map, id);
      final resultToMap = treino.toMap();

      // Assert
      expect(treino.id, id);
      expect(treino.nome, 'Treino A - Peito e Tríceps');
      expect(treino.itens.length, 1);
      expect(resultToMap, map);
      expect(treino.data, null);
      expect(treino.status, 'ativo');
    });
  });
}