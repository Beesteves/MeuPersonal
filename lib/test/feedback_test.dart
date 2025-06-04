import 'package:flutter_test/flutter_test.dart';
import 'package:tcc/models/feedback.dart';

void main() {
  group('FeedbackModel', () {
    test('toMap/fromMap', () {
      final feedback = FeedbackModel(
        id: 'f1',
        alunoId: 'a1',
        treinoId: 't1',
        textoFB: 'Muito bom!',
        videoFB: 'video',
        cargas: Map.from({'e1': 10}),
        data: DateTime.parse('2025-06-03'),
      );
      final map = feedback.toMap();
      final novo = FeedbackModel.fromMap(map, 'f1');

      expect(novo.textoFB, equals('Muito bom!'));
    });

    test('alunoId é mantido corretamente', () {
      final feedback = FeedbackModel(
        id: 'f2',
        alunoId: 'a2',
        treinoId: 't1',
        textoFB: 'Ótimo treino',
        videoFB: 'video',
        cargas: Map.from({'e1': 10}),
        data: DateTime.parse('2025-06-03'),
      );
      final map = feedback.toMap();
      final novo = FeedbackModel.fromMap(map, 'f2');

      expect(novo.alunoId, equals('a2'));
    });
  });
}
