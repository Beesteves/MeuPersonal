import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/exercicio.dart';

class DaoExercicio {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> salvar(Exercicio exercicio) async {
    if (exercicio.nome.isEmpty || exercicio.descricao.isEmpty || exercicio.tipo.isEmpty || exercicio.video.isEmpty) {
      print("Erro: Informacoes não podem ser vazias.");
      return;
    }
    try{
      await db.collection("exercicio").add(exercicio.toMap());
      print("Exercicio salvo com sucesso, id: ${exercicio.id}");
    }catch (error){
          (error) => print("Erro ao salvar exercicio: $error");
    }
  }

  Stream<List<Exercicio>> getExercicio() {
    return db.collection('exercicio').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Exercicio.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> deletar(String id) async {
    await db.collection("exercicio").doc(id).delete().catchError(
          (e) => print("Erro ao deletar exercicio: $e"),
        );
  }

  Future<void> editar(Exercicio exercicio) async{
    await db.collection("exercicio").doc(exercicio.id).update(exercicio.toMap());
  }

}