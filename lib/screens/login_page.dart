import 'package:flutter/material.dart';
import 'package:tcc/screens/app.dart';
import 'package:tcc/services/autenticacaoFirebase.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AutenticacaoFirebase auth = AutenticacaoFirebase();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _validaLogin());
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final message = await auth.signInWithEmailPassword(email, password);

    if (message.startsWith("Usuário autenticado:")) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const App()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _validaLogin() async {
    if (await auth.isUserLoggedIn()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const App()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A barra superior agora é um AppBar, que usará o appBarTheme.
      appBar: AppBar(
        title: const Text("LOGIN"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // 🔹 Campo de email
                    TextFormField(
                      controller: _emailController,
                      // A decoração é herdada do inputDecorationTheme.
                      decoration: const InputDecoration(labelText: "Email"),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Informe o email" : null,
                    ),
                    const SizedBox(height: 20),

                    // 🔹 Campo de senha
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      // A decoração é herdada do inputDecorationTheme.
                      decoration: const InputDecoration(labelText: "Senha"),
                      validator: (v) =>
                          v == null || v.isEmpty ? "Informe a senha" : null,
                    ),

                    const SizedBox(height: 30),

                    // 🔹 Botão de entrar estilizado
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        // O estilo é herdado do elevatedButtonTheme.
                        child: const Text("Entrar"),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Link para cadastro
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/cadastroPersonal');
                      },
                      // O estilo é herdado do textButtonTheme.
                      child: const Text('Cadastro de Personal'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
