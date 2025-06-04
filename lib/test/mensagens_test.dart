import 'package:flutter_test/flutter_test.dart';
import 'package:tcc/models/mensagem.dart';

void main() {
  group('Mensagem Model', () {
    test('toMap/fromMap', () {
      final mensagem = Mensagem(
        id: 'm1',
        remetenteId: 'r1',
        destinatarioId: 'd1',
        mensagem: 'Olá, tudo bem?',
        data: DateTime.parse('2025-06-03 10:00'),
      );
      final map = mensagem.toMap();
      final novo = Mensagem.fromMap(map, 'm1');

      expect(novo.mensagem, equals('Olá, tudo bem?'));
    });

    test('remetenteId e timestamp são mantidos', () {
      final mensagem = Mensagem(
        id: 'm2',
        remetenteId: 'r2',
        destinatarioId: 'd2',
        mensagem: 'Oi',
        data: DateTime.parse('2025-06-03 11:00'),
      );
      final map = mensagem.toMap();
      final novo = Mensagem.fromMap(map, 'm2');

      expect(novo.remetenteId, equals('r2'));
      expect(novo.data, equals(DateTime.parse('2025-06-03 11:00')));
    });
  });
}
