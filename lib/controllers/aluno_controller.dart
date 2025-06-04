import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/aluno.dart';

class DaoAluno {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> salvar(Aluno aluno) async {
    if (aluno.nome.isEmpty || aluno.email.isEmpty) {
      print("Erro: nome e email não podem ser vazios.");
      return;
    }
    try{
      await db.collection("alunos").add(aluno.toMap());
      print("Aluno salvo com sucesso, id: ${aluno.id}");
    }catch (error){
          (error) => print("Erro ao salvar aluno: $error");
    }
  }

  Stream<List<Aluno>> getAlunos() {
    return db.collection('alunos').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Aluno.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> deletar(String id) async {
    await db.collection("alunos").doc(id).delete().catchError(
          (e) => print("Erro ao deletar aluno: $e"),
        );
  }

  Future<void> editar(Aluno aluno) async{
    await db.collection("alunos").doc(aluno.id).update(aluno.toMap());
  }

}