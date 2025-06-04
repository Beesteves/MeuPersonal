import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  test('Adicionar treino no Firestore simulado', () async {
    final firestore = FakeFirebaseFirestore();

    final treinoData = {
      'nome': 'Treino A',
      'duracao': DateTime(2024, 5, 2).toIso8601String(),
      'itens': [
        {
          'exercicioId': 'e1',
          'metodoId': 'm1',
          'numSerie': 3,
          'numRepeticao': 12,
        }
      ]
    };

    await firestore.collection('treinos').add(treinoData);

    final snapshot = await firestore.collection('treinos').get();
    expect(snapshot.docs.length, 1);
    expect(snapshot.docs.first.data()['nome'], 'Treino A');
  });
}
