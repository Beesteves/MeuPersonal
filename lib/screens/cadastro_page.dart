import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tcc/screens/app.dart';
import 'package:tcc/screens/barra_cima_scaffold.dart';
import 'package:tcc/services/autenticacaoFirebase.dart';

class CadastroPage extends StatefulWidget {
  final String? personalId; // UID do personal (se cadastrando assistente/aluno)
  final String tipo; // 'personal', 'assistente' ou 'aluno'

  const CadastroPage({
    this.personalId,
    required this.tipo,
    Key? key,
  }) : super(key: key);

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AutenticacaoFirebase auth = AutenticacaoFirebase();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final nome = _nomeController.text.trim();

    final message = await auth.registerWithEmailPassword(email, password);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    final dados = <String, dynamic>{
      'id': user.uid,
      'nome': nome,
      'email': email,
      'tipo': widget.tipo,
      if (widget.personalId != null) 'personalId': widget.personalId,
      'criadoEm': FieldValue.serverTimestamp(),
    };

    try {
      await AutenticacaoFirebase.salvarDadosDoUsuario(dados);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
      );

      _validaLogin();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao salvar dados: $e')));
    }
  }

  void _validaLogin() async {
    if (widget.tipo == "personal") {
      if (await auth.isUserLoggedIn()) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const App()),
        );
      }
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BarraCimaScaffold(
      title: "Cadastro de ${widget.tipo[0].toUpperCase()}${widget.tipo.substring(1)}",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome"),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Informe o nome" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Informe o email" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Senha"),
                validator: (v) =>
                    (v == null || v.length < 6) ? "Mínimo 6 caracteres" : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Cadastrar",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
