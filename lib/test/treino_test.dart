import 'package:flutter_test/flutter_test.dart';
import 'package:tcc/models/item_treino.dart';
import 'package:tcc/models/treino.dart';
void main() {
  group('Treino Model', () {
    test('toMap/fromMap', () {
      final item1 = ItemTreino(
        id: '1',
        exercicioId: 'e1',
        metodoId: 'm1',
        numSerie: 3,
        numRepeticao: 20,
      );
      final item2 = ItemTreino(
        id: '2',
        exercicioId: 'e2',
        metodoId: 'm1',
        numSerie: 5,
        numRepeticao: 10,
      );
      final treino = Treino(
        id: 't1',
        nome: 'Treino A',
        duracao: 12,
        itens: [item1, item2],
      );
      final map = treino.toMap();
      final novo = Treino.fromMap(map, 't1');

      expect(novo.nome, equals(treino.nome));
      expect(novo.itens.first.numSerie, equals(item1.numSerie));
    });

    test('Lista de ItensTreino é mantida', () {
      final item1 = ItemTreino(
        id: '1',
        exercicioId: 'e3',
        metodoId: 'm1',
        numSerie: 4,
        numRepeticao: 12,
      );
      final item2 = ItemTreino(
        id: '2',
        exercicioId: 'e2',
        metodoId: 'm2',
        numSerie: 3,
        numRepeticao: 10,
      );
      final treino = Treino(id: 't2', nome: 'Treino B', duracao: 12, itens: [item1, item2]);
      final map = treino.toMap();
      final novo = Treino.fromMap(map, 't2');

      expect(novo.itens.length, equals(2));
    });
  });
}