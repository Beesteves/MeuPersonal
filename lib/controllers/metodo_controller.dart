import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/metodo.dart';

class DaoMetodo {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> salvar(Metodo metodo) async {
    if (metodo.nome.isEmpty || metodo.descricao.isEmpty) {
      print("Erro: nome e email não podem ser vazios.");
      return;
    }
    try{
      await db.collection("metodo").add(metodo.toMap());
      print("Metodo salvo com sucesso, id: ${metodo.id}");
    }catch (error){
          (error) => print("Erro ao salvar metodo: $error");
    }
  }

  Stream<List<Metodo>> getMetodo() {
    return db.collection('metodo').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Metodo.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> deletar(String id) async {
    await db.collection("metodo").doc(id).delete().catchError(
          (e) => print("Erro ao deletar metodo: $e"),
        );
  }

  Future<void> editar(Metodo metodo) async{
    await db.collection("metodo").doc(metodo.id).update(metodo.toMap());
  }

}