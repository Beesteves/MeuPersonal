import 'package:flutter_test/flutter_test.dart';
import 'package:tcc/models/aluno.dart';

void main() {
  group('Aluno Model', () {
    test('toMap retorna mapa correto', () {
      final aluno = Aluno(id: '123', nome: 'João', email: 'joao@email.com');
      final map = aluno.toMap();

      expect(map['nome'], 'João');
      expect(map['email'], 'joao@email.com');
    });

    test('fromMap cria Aluno corretamente', () {
      final map = {'nome': 'Maria', 'email': 'maria@email.com'};
      final aluno = Aluno.fromMap(map, 'abc123');

      expect(aluno.id, 'abc123');
      expect(aluno.nome, 'Maria');
      expect(aluno.email, 'maria@email.com');
    });
  });
}
