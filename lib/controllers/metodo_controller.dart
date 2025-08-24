import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/metodo.dart';

class DaoMetodo {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static const String _collection = 'users';
  static const String _subcollection = 'metodos';

  // Retorna a referência para a subcoleção 'metodos' de um personal específico
  static CollectionReference<Map<String, dynamic>> _getMetodosCollection(
      String personalId) {
    return db.collection(_collection).doc(personalId).collection(_subcollection);
  }

  static Future<void> salvar(Metodo metodo) async {
    if (metodo.nome.isEmpty || metodo.descricao.isEmpty) {
      throw Exception("Erro: nome e descrição não podem ser vazios.");
    }
    try {
      // Salva o método na subcoleção do personal correto
      await _getMetodosCollection(metodo.personalId).add(metodo.toMap());
      print("Método salvo com sucesso.");
    } catch (e) {
      print("Erro ao salvar método: $e");
      rethrow; // Propaga o erro para ser tratado na UI, se necessário
    }
  }

  static Stream<List<Metodo>> getMetodosDoPersonal(String personalId) {
    return _getMetodosCollection(personalId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Ao criar o objeto Metodo, passamos o personalId que já conhecemos
        return Metodo.fromMap(doc.data(), doc.id, personalId);
      }).toList();
    });
  }

  static Future<void> deletar(String personalId, String metodoId) async {
    try {
      await _getMetodosCollection(personalId).doc(metodoId).delete();
      print("Método deletado com sucesso.");
    } catch (e) {
      print("Erro ao deletar método: $e");
      rethrow;
    }
  }

  static Future<void> editar(Metodo metodo) async {
    try {
      await _getMetodosCollection(metodo.personalId).doc(metodo.id).update(metodo.toMap());
      print("Método editado com sucesso.");
    } catch (e) {
      print("Erro ao editar método: $e");
      rethrow;
    }
  }

}