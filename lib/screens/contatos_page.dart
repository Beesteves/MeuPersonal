import 'package:flutter/material.dart';
import 'package:tcc/controllers/usuario_controller.dart';
import 'package:tcc/models/usuario.dart';
import 'package:tcc/screens/chat_page.dart';

class ContatosPage extends StatelessWidget {
  final String userId;
  final String tipo; // "personal", "assistente", "aluno"

  const ContatosPage({super.key, required this.userId, required this.tipo});

  @override
  Widget build(BuildContext context) {
    Stream<List<Usuario>> stream;

    if (tipo == "personal") {
      stream = DaoUser.getAlunosDoPersonal(userId);
    } else if (tipo == "assistente") {
      stream = DaoUser.getAlunosDoAssitente(userId);
    } else {
      stream = DaoUser.streamUsuarioById(userId).asyncMap((aluno) async {
        final personal = await DaoUser.getUsuarioById(aluno!.personalId!); 
        final assistente = await DaoUser.getUsuarioById(aluno.assistenteId!);
        return [personal!, assistente!];
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Contatos")),
      body: StreamBuilder<List<Usuario>>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final contatos = snapshot.data!;
          return ListView.builder(
            itemCount: contatos.length,
            itemBuilder: (context, i) {
              final contato = contatos[i];
              return ListTile(
                // leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(contato.nome),
                subtitle: Text(contato.tipo),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        userId: userId,
                        contato: contato,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
