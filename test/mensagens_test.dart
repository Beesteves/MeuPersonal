import 'package:flutter_test/flutter_test.dart';
import 'package:tcc/models/mensagem.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- adicione isso

void main() {
  group('Mensagem Model', () {
    test('toMap/fromMap', () {
      final mensagem = Mensagem(
        remetenteId: 'r1',
        texto: 'Olá, tudo bem?',
        timestamp: DateTime(2025, 06, 03, 10, 00),
      );

      // Simula o map vindo do Firestore
      final map = {
        'remetenteId': mensagem.remetenteId,
        'texto': mensagem.texto,
        'timestamp': Timestamp.fromDate(mensagem.timestamp),
      };

      final novo = Mensagem.fromMap(map, '');

      expect(novo.texto, equals('Olá, tudo bem?'));
    });

    test('remetenteId e timestamp são mantidos', () {
      final mensagem = Mensagem(
        remetenteId: 'r2',
        texto: 'Oi',
        timestamp: DateTime(2025, 06, 03, 11, 00),
        tipo: 'mensagem',
      );

      final map = {
        'remetenteId': mensagem.remetenteId,
        'texto': mensagem.texto,
        'timestamp': Timestamp.fromDate(mensagem.timestamp),
        'tipo': mensagem.tipo,
      };

      final novo = Mensagem.fromMap(map, '');

      expect(novo.remetenteId, equals('r2'));
      expect(novo.timestamp, equals(DateTime.parse('2025-06-03 11:00')));
    });
  });
}
