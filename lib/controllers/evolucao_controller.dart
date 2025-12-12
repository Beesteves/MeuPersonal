import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/evolucao.dart';
import 'package:tcc/models/feedback.dart';

class DaoEvolucao {
  static final FirebaseFirestore db = FirebaseFirestore.instance;


static Future<List<Evolucao>> buscarEvolucaoExercicio(
    String alunoId, String exercicioId) async {
  try {
    final snapshot = await db
        .collection("users")
        .doc(alunoId)
        .collection("feedback")
        .orderBy("data", descending: false)
        .get();

    List<Evolucao> evolucoes = [];

    for (final doc in snapshot.docs) {
      final feed = FeedbackModel.fromMap(doc.data(), doc.id);

      if (feed.cargas != null && feed.cargas!.containsKey(exercicioId)) {
        final carga = (feed.cargas![exercicioId] ?? 0).toDouble();

        final dataFormatada =
            "${feed.data.year.toString().padLeft(4,'0')}-${feed.data.month.toString().padLeft(2,'0')}-${feed.data.day.toString().padLeft(2,'0')}";

        evolucoes.add(Evolucao(data: dataFormatada, carga: carga));
      }
    }

    return evolucoes;
  } catch (e) {
    print("❌ Erro ao buscar evolução do exercício: $e");
    return [];
  }
}



}