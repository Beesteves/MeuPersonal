import 'package:flutter/material.dart';
import 'package:tcc/controllers/exercicio_controller.dart';
import 'package:tcc/models/exercicio.dart';
import 'package:tcc/screens/barra_cima_scaffold.dart';
import 'package:tcc/screens/cria_exercicio_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ListaExerciciosPage extends StatelessWidget {
  final String personalId;


  const ListaExerciciosPage({
    super.key,
    required this.personalId,

  });

  @override
  Widget build(BuildContext context) {
    return BarraCimaScaffold(
      title: "Exercícios",
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Exercicio>>(
              stream: DaoExercicio.getExerciciodoPersonal(personalId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                final exercicios = snapshot.data ?? [];
                if (exercicios.isEmpty) {
                  return const Center(
                      child: Text('Nenhum exercício cadastrado.'));
                }

                return ListView.builder(
                  itemCount: exercicios.length,
                  itemBuilder: (context, i) {
                    final exercicio = exercicios[i];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(
                          exercicio.nome,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(exercicio.descricao, maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 5),
                            Text(
                              'Tipo: ${exercicio.tipo}',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            if (value == 'editar') {
                              print('Editar ${exercicio.id}');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CriaExercicioPage(
                                    personalId: personalId,
                                    exercicio: exercicio,
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
                                        'Tem certeza que deseja deletar o exercício "${exercicio.nome}"?'),
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
                                          DaoExercicio.deletar(personalId, exercicio.id);
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
                        onTap: () {
                          // Se o vídeo existir, abre ao tocar no card
                          if (exercicio.video != null &&
                              exercicio.video!.isNotEmpty) {
                            final uri = Uri.tryParse(exercicio.video!);
                            if (uri != null) {
                              canLaunchUrl(uri).then((can) async {
                                if (can) {
                                  await launchUrl(uri);
                                } else {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Não foi possível abrir o vídeo.')),
                                  );
                                }
                              });
                            }
                          }
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
                    builder: (_) => CriaExercicioPage(
                      personalId: personalId,
                    ),
                  ),
                );
              },
              child: const Text(
                "+ Adicionar Exercício",
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
