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
}