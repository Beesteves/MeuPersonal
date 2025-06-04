import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/treino.dart';

class DaoTreino {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> salvar(Treino treino) async {
    if (treino.nome.isEmpty || treino.itens.isEmpty|| treino.duracao.isNaN) {
      print("Erro: Informacoes não podem ser vazias.");
      return;
    }
    try{
      await db.collection("treino").add(treino.toMap());
      print("Treino salvo com sucesso, id: ${treino.id}");
    }catch (error){
          (error) => print("Erro ao salvar treino: $error");
    }
  }

  Stream<List<Treino>> getTreino() {
    return db.collection('treino').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Treino.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> deletar(String id) async {
    await db.collection("treino").doc(id).delete().catchError(
          (e) => print("Erro ao deletar treino: $e"),
        );
  }

  Future<void> editar(Treino treino) async{
    await db.collection("treino").doc(treino.id).update(treino.toMap());
  }

}