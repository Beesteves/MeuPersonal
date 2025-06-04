import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/assistente.dart';

class DaoAssistente {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> salvar(Assistente assistente) async {
    if (assistente.nome.isEmpty || assistente.email.isEmpty) {
      print("Erro: nome e email não podem ser vazios.");
      return;
    }
    try{
      await db.collection("assitente").add(assistente.toMap());
      print("Assistente salvo com sucesso, id: ${assistente.id}");
    }catch (error){
          (error) => print("Erro ao salvar assistente: $error");
    }
  }

  Stream<List<Assistente>> getAssistente() {
    return db.collection('assistente').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Assistente.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> deletar(String id) async {
    await db.collection("assistente").doc(id).delete().catchError(
          (e) => print("Erro ao deletar assistente: $e"),
        );
  }

  Future<void> editar(Assistente assistente) async{
    await db.collection("assistente").doc(assistente.id).update(assistente.toMap());
  }

}