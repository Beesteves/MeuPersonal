import 'package:flutter/material.dart';
import 'package:tcc/controllers/exercicio_controller.dart';
import 'package:tcc/models/exercicio.dart';
import 'package:tcc/screens/barra_cima_scaffold.dart';
import 'package:tcc/screens/cria_exercicio_page.dart';
import 'package:tcc/screens/video_exercicio_widget.dart';

class ListaExerciciosPage extends StatefulWidget {
  final String personalId;
  final String userTipo;

  const ListaExerciciosPage({
    super.key,
    required this.personalId,
    required this.userTipo,
  });

  bool get podeEditar => userTipo == 'personal';

  @override
  State<ListaExerciciosPage> createState() => _ListaExerciciosPageState();
}

class _ListaExerciciosPageState extends State<ListaExerciciosPage> {
  String? filtroTipo;
  String busca = '';

  @override
  Widget build(BuildContext context) {
    return BarraCimaScaffold(
      title: "Exercícios",
      body: StreamBuilder<List<Exercicio>>(
        stream: DaoExercicio.getExerciciodoPersonal(widget.personalId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final todosExercicios = snapshot.data ?? [];
          if (todosExercicios.isEmpty) {
            return const Center(child: Text('Nenhum exercício cadastrado.'));
          }

          // 🔹 Lista de tipos únicos para o filtro
          final tipos = todosExercicios
              .map((e) => e.tipo?.trim() ?? '')
              .where((t) => t.isNotEmpty)
              .toSet()
              .toList()
            ..sort();

          // 🔹 Aplica filtro por tipo e busca por nome
          final exerciciosFiltrados = todosExercicios.where((e) {
            final correspondeTipo = filtroTipo == null
                ? true
                : (e.tipo ?? '').toLowerCase() == filtroTipo!.toLowerCase();
            final correspondeBusca = e.nome.toLowerCase().contains(busca.toLowerCase());
            return correspondeTipo && correspondeBusca;
          }).toList();

          return Column(
            children: [
              // 🔹 Barra de busca e filtro
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Campo de busca
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: "Buscar exercício",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            busca = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Dropdown de filtro por tipo
                    DropdownButton<String>(
                      value: filtroTipo ?? "Todos",
                      items: ["Todos", ...tipos]
                          .map((tipo) => DropdownMenuItem(
                                value: tipo,
                                child: Text(tipo),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          filtroTipo = value == "Todos" ? null : value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Lista de exercícios
              Expanded(
                child: ListView.builder(
                  itemCount: exerciciosFiltrados.length,
                  itemBuilder: (context, i) {
                    final exercicio = exerciciosFiltrados[i];                    
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ExpansionTile(
                        title: Text(
                          exercicio.nome,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   exercicio.descricao,
                            //   maxLines: 2,
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                            const SizedBox(height: 5),
                            Text(
                              'Tipo: ${exercicio.tipo ?? "Não informado"}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        trailing: widget.podeEditar?
                         PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            if (value == 'editar') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CriaExercicioPage(
                                    personalId: widget.personalId,
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
                                                TextStyle(color: Colors.red)), // Manter cor para ação destrutiva
                                        onPressed: () {
                                          DaoExercicio.deletar(widget.personalId, exercicio.id);
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
                              const <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                                value: 'editar', child: Text('Editar')),
                            PopupMenuItem<String>(
                                value: 'deletar', child: Text('Deletar')),
                          ],
                        ): null,
                        children: [
                          const Divider(),
                          const SizedBox(height: 8,),
                          const Text("Descrição do Exercício"),
                          const SizedBox(height: 4),
                          Text(
                          exercicio.descricao.isNotEmpty ? exercicio.descricao : "Nenhuma descrição disponível."),
                          if(exercicio.video != null && exercicio.video!.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Text("Vídeo Demonstrativo"),
                            const SizedBox(height: 8),
                            VideoExercicioWidget(
                              url: exercicio.video!,
                              textColor: Theme.of(context).colorScheme.onSurface, // Usar cor do tema
                            ),                                      
                          ],           

                        ],
                      ),
                    );
                  },
                ),
              ),

              // Botão para adicionar exercício
              if (widget.podeEditar)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CriaExercicioPage(
                          personalId: widget.personalId,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "+ Adicionar Exercício",
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
