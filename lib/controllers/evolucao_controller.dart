import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/evolucao.dart';
import 'package:tcc/models/feedback.dart';

class DaoEvolucao {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // static Future<void> salvar(Evolucao evolucao) async {
  //   if (evolucao.exercicioId.isEmpty || evolucao.carga.isNaN) {
  //     print("Erro: campos não podem ser vazios.");
  //     return;
  //   }
  //   try{
  //     await db.collection("evolucaos").add(evolucao.toMap());
  //     print("Evolucao salvo com sucesso, id: ${evolucao.id}");
  //   }catch (error){
  //         (error) => print("Erro ao salvar evolucao: $error");
  //   }
  // }

  // Stream<List<Evolucao>> getEvolucao() {
  //   return db.collection('evolucao').snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       return Evolucao.fromMap(doc.data(), doc.id);
  //     }).toList();
  //   });
  // }

  // Future<void> deletar(String id) async {
  //   await db.collection("evolucao").doc(id).delete().catchError(
  //         (e) => print("Erro ao deletar evolucao: $e"),
  //       );
  // }

  // Future<void> editar(Evolucao evolucao) async{
  //   await db.collection("evolucao").doc(evolucao.id).update(evolucao.toMap());
  // }
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

        // Converte DateTime → String para Evolucao
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