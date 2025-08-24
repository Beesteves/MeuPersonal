import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/exercicio.dart';

class DaoExercicio {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static const String _usersCollection = 'users';

  static const String _exerciciosSubcollection = 'exercicios';

  static CollectionReference<Map<String, dynamic>> _getExerciciosCollection(
      String personalId) {
    return db
        .collection(_usersCollection)
        .doc(personalId)

        .collection(_exerciciosSubcollection);
  }

  static Future<void> salvar(Exercicio exercicio) async {
    if (exercicio.nome.isEmpty) {
      throw Exception("Erro: o nome do exercício não pode ser vazio.");
    }
    try {
      await _getExerciciosCollection(exercicio.personalId)
          .add(exercicio.toMap());
      print("Exercício salvo com sucesso.");
    } catch (e) {
      print("Erro ao salvar exercício: $e");
      rethrow;
    }
  }

  static Stream<List<Exercicio>> getExerciciodoPersonal(String personalId) {
    return _getExerciciosCollection(personalId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Exercicio.fromMap(doc.data(), doc.id, personalId);
      }).toList();
    });
  }

  static Future<void> deletar(
      String personalId, String exercicioId) async {
    try {
      await _getExerciciosCollection(personalId)
          .doc(exercicioId)
          .delete();
      print("Exercício deletado com sucesso.");
    } catch (e) {
      print("Erro ao deletar exercício: $e");
      rethrow;
    }
  }

  static Future<void> editar(Exercicio exercicio) async {
    try {
      await _getExerciciosCollection(exercicio.personalId)
          .doc(exercicio.id)
          .update(exercicio.toMap());
      print("Exercício editado com sucesso.");
    } catch (e) {
      print("Erro ao editar exercício: $e");
      rethrow;
    }
  }
}