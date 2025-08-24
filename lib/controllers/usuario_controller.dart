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


}