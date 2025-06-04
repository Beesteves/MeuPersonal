import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/evolucao.dart';

class DaoEvolucao {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> salvar(Evolucao evolucao) async {
    if (evolucao.exercicioId.isEmpty || evolucao.carga.isNaN) {
      print("Erro: campos não podem ser vazios.");
      return;
    }
    try{
      await db.collection("evolucaos").add(evolucao.toMap());
      print("Evolucao salvo com sucesso, id: ${evolucao.id}");
    }catch (error){
          (error) => print("Erro ao salvar evolucao: $error");
    }
  }

  Stream<List<Evolucao>> getEvolucao() {
    return db.collection('evolucao').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Evolucao.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> deletar(String id) async {
    await db.collection("evolucao").doc(id).delete().catchError(
          (e) => print("Erro ao deletar evolucao: $e"),
        );
  }

  Future<void> editar(Evolucao evolucao) async{
    await db.collection("evolucao").doc(evolucao.id).update(evolucao.toMap());
  }

}