import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AutenticacaoFirebase {
  Future<String> signInWithEmailPassword(String email, String password) async {
    try {
      final cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Usuário autenticado: ${cred.user!.uid}";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return "Usuário não encontrado";
      if (e.code == 'wrong-password') return "Senha incorreta";
      return "Erro de autenticação";
    }
  }

  Future<String> registerWithEmailPassword(String email, String password) async {
    try {
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return "Usuário registrado com sucesso: ${cred.user!.uid}";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') return "A senha é muito fraca.";
      if (e.code == 'email-already-in-use') return "A conta já existe para esse email.";
      return "Erro de registro";
    } catch (e) {
      return "Erro: $e";
    }
  }

  Future<String> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      return "Usuário desconectado com sucesso";
    } catch (e) {
      return "Erro ao desconectar: $e";
    }
  }

  Future<bool> isUserLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user !=        null; // Retorna true se o usuário estiver logado, caso contrário, false
  }

  /// cria/atualiza doc do usuário logado em `users/{uid}`
  static Future<void> salvarDadosDoUsuario(Map<String, dynamic> dados) async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) throw FirebaseAuthException(code: 'not-authenticated', message: 'Usuário não autenticado');

    // remove campos nulos
    final sanitized = Map<String, dynamic>.from(dados)
      ..removeWhere((k, v) => v == null);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(usuario.uid)
        .set(sanitized, SetOptions(merge: true));
  }

  static Future<void> salvarDados(Map<String, dynamic> dados) async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) throw FirebaseAuthException(code: 'not-authenticated', message: 'Usuário não autenticado');

    final sanitized = Map<String, dynamic>.from(dados)
      ..removeWhere((k, v) => v == null);

    // usa set+merge para não falhar quando o doc ainda não existe
    await FirebaseFirestore.instance
        .collection('users')
        .doc(usuario.uid)
        .set(sanitized, SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>?> buscarDadosDoUsuario() async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(usuario.uid)
        .get();

    return doc.data();
  }
}
