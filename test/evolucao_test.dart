import 'package:flutter_test/flutter_test.dart';
import 'package:tcc/models/evolucao.dart';

void main() {
  group('Evolucao Model', () {
    test('toMap/fromMap mantém peso e data', () {
      final evolucao = Evolucao(
        carga: 70.5,
        data: '2025-06-03',
      );
      final map = evolucao.toMap();
      final novo = Evolucao.fromMap(map, 'e1');

      expect(novo.carga, equals(70.5));
      expect(novo.data, equals('2025-06-03'));
    });

  });
}