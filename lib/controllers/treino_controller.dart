import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/treino.dart';

class DaoTreino {
  static final _db = FirebaseFirestore.instance;
  static final _collection = _db.collection('treinos');

  static Future<void> salvar(Treino treino) async {
    // O ID será gerado automaticamente pelo Firestore
    await _collection.add(treino.toMap());
  }

  static Future<void> editar(Treino treino) async {
    await _collection.doc(treino.id).update(treino.toMap());
  }

  static Future<void> deletar(String id) async {
    await _collection.doc(id).delete();
  }

  static Stream<List<Treino>> getTreinosDoPersonal(String personalId) {
    return _collection
        .where('personalId', isEqualTo: personalId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Treino.fromMap(data, doc.id);
      }).toList();
    });
  }

   static Future<void> atribuirTreino(
    Treino modelo,
    String alunoId,
  ) async {
    try {
      final alunoRef = _db.collection("users").doc(alunoId);
      await alunoRef.collection("treinos").add(modelo.toMap());
    } catch (e) {
      print("Erro ao atribuir treino: $e");
      rethrow;
    }
  }

  /// 🔹 Buscar treinos de um aluno
  static Stream<List<Treino>> getTreinosDoAluno(String alunoId) {
    return _db
        .collection("users")
        .doc(alunoId)
        .collection("treinos")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Treino.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

 static Future<void> adicionaTreinoFeito(Treino treino, String alunoId) async {
    getStatusTreino(treino, alunoId);
    
    await _db
    .collection("users")
    .doc(alunoId)
    .collection("treinos")
    .doc(treino.id)
    .update({
      'feitos': FieldValue.increment(1),
    });
  }

  static Future<void> getStatusTreino(Treino treino, String alunoId) async {

    final dataFim = treino.data!.add(Duration(days: treino.duracao * 7));
    final agora = DateTime.now();

    if (dataFim.isBefore(agora) || treino.status == "bloquado"){
      await _db
    .collection("users")
    .doc(alunoId)
    .collection("treinos")
    .doc(treino.id)
    .update({
      'status': "bloqueado",
    });
    }
  }

  static Future<void> desatribuir(String id, String alunoId) async {
    await _db
    .collection("users")
    .doc(alunoId)
    .collection("treinos")
    .doc(id)
    .delete();
  }

  static Future<void> bloquear(Treino treino, String alunoId) async {
    await _db
    .collection("users")
    .doc(alunoId)
    .collection("treinos")
    .doc(treino.id)
    .update({
      'status': "bloqueado",
    });
  }



}


