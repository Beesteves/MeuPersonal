import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/item_treino.dart';

class DaoItens {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> salvar(ItemTreino treino) async {
    if (treino.exercicioId.isEmpty || treino.metodoId.isEmpty || treino.numSerie.isNaN || treino.numRepeticao.isNaN) {
      print("Erro: Informacoes não podem ser vazias.");
      return;
    }
    try{
      await db.collection("item_treino").add(treino.toMap());
      print("Treino salvo com sucesso, id: ${treino.id}");
    }catch (error){
          (error) => print("Erro ao salvar treino: $error");
    }
  }

  Stream<List<ItemTreino>> getItemTreino() {
    return db.collection('item_treino').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ItemTreino.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> deletar(String id) async {
    await db.collection("item_treino").doc(id).delete().catchError(
          (e) => print("Erro ao deletar exercicio: $e"),
        );
  }

  Future<void> editar(ItemTreino treino) async{
    await db.collection("item_treino").doc(treino.id).update(treino.toMap());
  }

}