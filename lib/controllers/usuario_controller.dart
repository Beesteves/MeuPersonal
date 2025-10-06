import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tcc/firebase_options.dart';
import 'package:tcc/models/usuario.dart';

class DaoUser{
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static void inicializa() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  static String? _getUid() {
    final User? usuario = FirebaseAuth.instance.currentUser;
    return usuario?.uid;
  }

  static Stream<List<Usuario>> getAlunosDoPersonal(String personalId) {
    return db
        .collection('users')
        .where('tipo', isEqualTo: 'aluno')
        .where('personalId', isEqualTo: personalId)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
     return querySnapshot.docs.map((doc) {
        return Usuario.fromMap(doc.data() as Map<String, dynamic>)
          ..id = doc.id;
      }).toList();
    });
  }

  static Stream<List<Usuario>> getAssistentesDoPersonal(String personalId) {
    return db
        .collection('users')
        .where('tipo', isEqualTo: 'assistente')
        .where('personalId', isEqualTo: personalId)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
     return querySnapshot.docs.map((doc) {
        return Usuario.fromMap(doc.data() as Map<String, dynamic>)
          ..id = doc.id;
      }).toList();
    });
  }

  static Stream<List<Usuario>> getAlunosDoAssitente(String assistenteId) {
    return db
        .collection('users')
        .where('tipo', isEqualTo: 'aluno')
        .where('assistenteId', isEqualTo: assistenteId)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
     return querySnapshot.docs.map((doc) {
        return Usuario.fromMap(doc.data() as Map<String, dynamic>)
          ..id = doc.id;
      }).toList();
    });
  }

  static Stream<Usuario?> streamUsuarioById(String userId) {
    return db.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return Usuario.fromMap(doc.data() as Map<String, dynamic>)
          ..id = doc.id;
      }
      return null;
    });
  }

  static definirAssistenteParaAluno(
    String alunoId, String assistenteId) async {
    try {
      await db.collection('users').doc(alunoId).update({
        'assistenteId': assistenteId,
      });
      print("✅ Assistente $assistenteId vinculado ao aluno $alunoId");
    } catch (e) {
      print("❌ Erro ao definir assistente: $e");
      rethrow;
    }
  }

  static Future<Usuario?> getUsuarioById(String userId) async {
    try {
      final doc = await db.collection('users').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        return Usuario.fromMap(doc.data() as Map<String, dynamic>)
          ..id = doc.id;
      } else {
        return null; // usuário não encontrado
      }
    } catch (e) {
      print("❌ Erro ao buscar usuário: $e");
      return null;
    }
  }


}