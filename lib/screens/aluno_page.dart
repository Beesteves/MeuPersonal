import 'package:flutter/material.dart';
import 'package:tcc/controllers/usuario_controller.dart';
import 'package:tcc/models/usuario.dart';
import 'package:tcc/screens/cadastro_page.dart';


class ListaAlunosScreen extends StatelessWidget {
  final String personalIds;
  
  ListaAlunosScreen({super.key, required this.personalIds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Lista de alunos
          Expanded(
            child: StreamBuilder<List<Usuario>>(
              stream: DaoUser.getAlunosDoPersonal(personalIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                final alunos = snapshot.data ?? [];
                if (alunos.isEmpty) {
                  return const Center(child: Text('Nenhum aluno cadastrado.'));
                }

                return ListView.builder(
                  itemCount: alunos.length,
                  itemBuilder: (context, i) {
                    final a = alunos[i];
                    return Card(
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: ListTile(
                        title: Text(
                          a.nome,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Status: Ativo\nULTIMA TREINO: --/--/----\nTEMPO PARA TERMINAR: -- SEMANAS",
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: const Icon(Icons.chevron_right, size: 28),
                        onTap: () {
                          // navegar para detalhe do aluno (se quiser)
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CadastroPage(
                      tipo: 'aluno',
                      personalId: personalIds, // passa o vínculo
                    ),
                  ),
                );
              },
              child: const Text(
                "+ Adicionar Aluno",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}