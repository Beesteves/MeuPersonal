import 'package:flutter/material.dart';
import 'package:tcc/controllers/treino_controller.dart';
import 'package:tcc/models/treino.dart';
import 'package:tcc/screens/barra_cima_scaffold.dart';
import 'package:tcc/screens/detalhes_treino_page.dart';
import 'package:tcc/screens/cria_treino_page.dart';

class ListaTreinosPage extends StatelessWidget {
  final String personalId;

  const ListaTreinosPage({
    super.key,
    required this.personalId,
  });

  @override
  Widget build(BuildContext context) {
    return BarraCimaScaffold(
      title: "Treinos",
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Treino>>(
              stream: DaoTreino.getTreinosDoPersonal(personalId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                final treinos = snapshot.data ?? [];
                if (treinos.isEmpty) {
                  return const Center(
                      child: Text('Nenhum treino cadastrado.'));
                }

                return ListView.builder(
                  itemCount: treinos.length,
                  itemBuilder: (context, i) {
                    final treino = treinos[i];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetalhesTreinoPage(
                                treino: treino,
                                personalId: personalId,
                              ),
                            ),
                          );
                        },
                        title: Text(
                          treino.nome,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            'Duração: ${treino.duracao} semanas | Exercícios: ${treino.itens.length}'),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            if (value == 'editar') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CriaTreinoPage(
                                    personalId: personalId,
                                    treino: treino,
                                  ),
                                ),
                              );
                            } else if (value == 'deletar') {
                              showDialog(
                                context: context,
                                builder: (BuildContext ctx) {
                                  return AlertDialog(
                                    title: const Text('Confirmar Exclusão'),
                                    content: Text(
                                        'Tem certeza que deseja deletar o treino "${treino.nome}"?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Deletar',
                                            style:
                                                TextStyle(color: Colors.red)),
                                        onPressed: () {
                                          DaoTreino.deletar(treino.id);
                                          Navigator.of(ctx).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                                value: 'editar', child: Text('Editar')),
                            const PopupMenuItem<String>(
                                value: 'deletar', child: Text('Deletar')),
                          ],
                        ),
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
                    builder: (_) => CriaTreinoPage(
                      personalId: personalId,
                    ),
                  ),
                );
              },
              child: const Text(
                "+ Adicionar Treino",
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
