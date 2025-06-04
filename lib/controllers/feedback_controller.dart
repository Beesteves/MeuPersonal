import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/feedback.dart';

class DaoFeed {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<void> salvar(FeedbackModel feed) async {
    if (feed.treinoId.isEmpty) {
      print("Erro: campos não podem ser vazios.");
      return;
    }
    try{
      await db.collection("feedback").add(feed.toMap());
      print("Feedback salvo com sucesso, id: ${feed.id}");
    }catch (error){
          (error) => print("Erro ao salvar Feedback: $error");
    }
  }

  Stream<List<FeedbackModel>> getFeedback() {
    return db.collection('feedback').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return FeedbackModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> deletar(String id) async {
    await db.collection("feedback").doc(id).delete().catchError(
          (e) => print("Erro ao deletar feedback: $e"),
        );
  }

  Future<void> editar(FeedbackModel feed) async{
    await db.collection("feedback").doc(feed.id).update(feed.toMap());
  }

}