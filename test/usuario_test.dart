import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tcc/models/usuario.dart';

void main() {
  group('Usuario Model', () {
    test('fromMap e toMap devem funcionar corretamente', () {
      // Arrange
      final now = DateTime.now();
      final timestamp = Timestamp.fromDate(now);

      final map = {
        'id': '',
        'nome': 'João Aluno',
        'email': 'joao@aluno.com',
        'tipo': 'aluno',
        'criadoEm': timestamp,
        'personalId': 'personal456',
        'assistenteId': 'assistente789',
      };

      // Act
      final usuario = Usuario.fromMap(map);
      final resultToMap = usuario.toMap();

      // Assert
      expect(resultToMap, map);
    });
  });
}