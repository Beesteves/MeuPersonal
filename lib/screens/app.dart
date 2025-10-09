import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc/screens/aluno_page.dart';
import 'package:tcc/screens/base_scaffold.dart';
import 'package:tcc/screens/contatos_page.dart';
import 'package:tcc/screens/screensAluno/menu_aluno_page.dart';
import 'package:tcc/screens/menu_personal_page.dart';
import 'package:tcc/screens/screensAluno/treinos_alunos_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentIndex = 0;
  String? _tipoUsuario;
  String? _userId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarTipoUsuario();
  }

  Future<void> _carregarTipoUsuario() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (doc.exists) {
        setState(() {
          _tipoUsuario = doc['tipo'];
          _userId = uid;      // Guarda o UID no estado
          _isLoading = false;
        });
      } else {
        setState(() {
          _tipoUsuario = "desconhecido";
          _userId = uid;
          _isLoading = false;
        });
      }
    } else {
      // Usuário não logado (opcional: tratar essa situação)
      setState(() {
        _tipoUsuario = "desconhecido";
        _isLoading = false;
      });
    }
    
  }
  

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Definindo páginas com base no tipo do usuário
    final List<Widget> pages;
    final List<String> titles;

    if (_tipoUsuario == "personal" || _tipoUsuario == "assistente") {
      pages = [
        ListaAlunosScreen(personalIds: _userId ?? ""),
        MenuPagePersonal(personalIds: _userId ?? ""),
        ContatosPage(userId: _userId ?? "", tipo: _tipoUsuario!),
      ];
      titles = ["ALUNOS", "MENU", "CHAT"];
    } else {
      // Aluno
      pages = [
        ListaTreinosAlunoScreen(alunoId: _userId ?? ""),
        MenuPageAluno(alunoId: _userId ?? ""),
        ContatosPage(userId: _userId ?? "", tipo: "aluno"),
      ];
      titles = ["TREINOS", "MENU", "CHAT"];
    }

    return Scaffold(
      body: BaseScaffold(
        title: titles[_currentIndex],
        body: pages[_currentIndex],
        currentIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
