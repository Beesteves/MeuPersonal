import 'package:flutter/material.dart';
import 'package:tcc/controllers/usuario_controller.dart';
import 'package:tcc/models/usuario.dart';
import 'package:tcc/screens/aluno_page.dart';
import 'package:tcc/screens/barra_cima_scaffold.dart';
import 'package:tcc/screens/cadastro_page.dart';

class ListaAssistentesScreen extends StatelessWidget {
  final String personalIds;

  const ListaAssistentesScreen({super.key, required this.personalIds});

  @override
  Widget build(BuildContext context) {
    return BarraCimaScaffold(
      title: "Assistentes", 
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Usuario>>(
              stream: DaoUser.getAssistentesDoPersonal(personalIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                final assistentes = snapshot.data ?? [];
                if (assistentes.isEmpty) {
                  return const Center(
                      child: Text('Nenhum assistente cadastrado.'));
                }

                return ListView.builder(
                  itemCount: assistentes.length,
                  itemBuilder: (context, i) {
                    final a = assistentes[i];
                    return Card(
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: ListTile(
                        title: Text(
                          a.nome,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                          "Tem alunos...",
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing:
                            const Icon(Icons.chevron_right, size: 28),
                        onTap: () {
                          Navigator.push( // Navega para a lista de alunos do assistente
                            context,
                            MaterialPageRoute(
                              builder: (_) => ListaAlunosScreen(
                                assistenteIds: a.id,
                              ), 
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CadastroPage(
                      tipo: 'assistente',
                      personalId: personalIds,
                    ),
                  ),
                );
              },
              child: const Text(
                "+ Adicionar Assistente",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
