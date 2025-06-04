import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/personal.dart';

class DaoPersonal {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> salvar(Personal personal) async {
    if (personal.nome.isEmpty || personal.email.isEmpty) {
      print("Erro: nome e email não podem ser vazios.");
      return;
    }
    try{
      await db.collection("alunos").add(personal.toMap());
      print("Personal salvo com sucesso, id: ${personal.id}");
    }catch (error){
          (error) => print("Erro ao salvar personal: $error");
    }
  }

  Stream<List<Personal>> getPlunos() {
    return db.collection('personal').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Personal.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> deletar(String id) async {
    await db.collection("personal").doc(id).delete().catchError(
          (e) => print("Erro ao deletar personal: $e"),
        );
  }

  Future<void> editar(Personal personal) async{
    await db.collection("personal").doc(personal.id).update(personal.toMap());
  }

}