import 'package:flutter/material.dart';
import 'package:tcc/controllers/treino_controller.dart';
import 'package:tcc/controllers/usuario_controller.dart';
import 'package:tcc/models/treino.dart';
import 'package:tcc/models/usuario.dart';
import 'package:tcc/screens/cadastro_page.dart';
import 'package:tcc/screens/perfil_aluno_page.dart';

class ListaAlunosScreen extends StatelessWidget {
  final String? personalIds;
  final String? assistenteIds;

  const ListaAlunosScreen({
    super.key,
    this.personalIds,
    this.assistenteIds,
  });

  @override
  Widget build(BuildContext context) {
    final bool isParaAssistente = assistenteIds != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Usuario>>(
              stream: isParaAssistente
                  ? DaoUser.getAlunosDoAssitente(assistenteIds!)
                  : DaoUser.getAlunosDoPersonal(personalIds!),
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
                    final aluno = alunos[i];
                    
                    // 🔥 Para cada aluno, obtemos os treinos em um StreamBuilder separado
                    return StreamBuilder<List<Treino>>(
                      stream: DaoTreino.getTreinosDoAluno(aluno.id),
                      builder: (context, treinoSnapshot) {
                        if (treinoSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox.shrink(); 
                        }

                        final treinos = treinoSnapshot.data ?? [];
                        Treino? ultimoTreino;

                        if (treinos.isNotEmpty) {
                          treinos.sort((a, b) {
                            final dataA = a.data ?? DateTime(2000);
                            final dataB = b.data ?? DateTime(2000);
                            return dataB.compareTo(dataA);
                          });
                          ultimoTreino = treinos.first;
                        }

                        String status = "Sem treino";
                        String ultimaData = "--/--/----";
                        // String tempoRestante = "-- semanas";

                        if (ultimoTreino != null) {
                          final dataTreino = ultimoTreino.data ?? DateTime.now();

                          status = ultimoTreino.status;

                          ultimaData =
                              "${dataTreino.day.toString().padLeft(2, '0')}/${dataTreino.month.toString().padLeft(2, '0')}/${dataTreino.year}";

                        }

                        return Card(
                          color: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: ListTile(
                            title: Text(
                              aluno.nome,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: (aluno.assistenteId != null)
                              ? FutureBuilder<Usuario?>(
                                future: DaoUser.getUsuarioById(aluno.assistenteId!),
                                builder:(context, snapshotAssistente) {
                                  final assistenteNome = snapshotAssistente.data?.nome ?? '---';
                                  return Text(
                                    "Status: $status\n"
                                    "Último treino: $ultimaData\n"
                                    "Assistente: ${assistenteNome}",
                                    style: const TextStyle(fontSize: 14),
                                  );
                                },
                              )
                            : Text(
                              "Status: $status\n"
                              "Último treino: $ultimaData\n"
                              "Assistente: ---",
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: const Icon(Icons.chevron_right, size: 28),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AlunoPerfilPage(
                                    alunoId: aluno.id,
                                    personalId: aluno.personalId!,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          // botão de adicionar aluno (apenas para personal)
          if (!isParaAssistente)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CadastroPage(
                        tipo: 'aluno',
                        personalId: personalIds!,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "+ Adicionar Aluno",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
