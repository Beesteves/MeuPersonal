import 'package:flutter/material.dart';
import 'package:tcc/controllers/metodo_controller.dart';
import 'package:tcc/models/metodo.dart';
import 'package:tcc/screens/barra_cima_scaffold.dart';
import 'package:tcc/screens/cria_metodo.dart';

// Função auxiliar para converter uma string hexadecimal em um objeto Color.
Color _hexToColor(String hexCode) {
  try {
    final hex = hexCode.replaceAll('#', '');
    // Adiciona o prefixo 'FF' para opacidade total se não estiver presente
    final fullHex = hex.length == 6 ? 'FF$hex' : hex;
    return Color(int.parse('0x$fullHex'));
  } catch (e) {
    // Retorna uma cor padrão em caso de erro no parsing
    return Colors.grey[100]!;
  }
}

class ListaMetodosScreen extends StatelessWidget {
  final String personalIds;
  final String userTipo;


  const ListaMetodosScreen({super.key, required this.personalIds, required this.userTipo});

  bool get podeEditar => userTipo == 'personal';

  @override
  Widget build(BuildContext context) {
    return BarraCimaScaffold(
      title: "Métodos", 
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Metodo>>(
              stream: DaoMetodo.getMetodosDoPersonal(personalIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                final metodos = snapshot.data ?? [];
                if (metodos.isEmpty) {
                  return const Center(
                      child: Text('Nenhum método cadastrado.'));
                }

                return ListView.builder(
                  itemCount: metodos.length,
                  itemBuilder: (context, i) {
                    final metodo = metodos[i];
                    final cardColor = _hexToColor(metodo.cor);
                    final textColor = cardColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: cardColor.withOpacity(1), 
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                    BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(color: cardColor.withOpacity(0.7)), 
                      ),
                      child: ListTile(
                        title: Text(
                          metodo.nome,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          metodo.descricao,
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor.withOpacity(0.9),
                          ),
                        ),
                        trailing: podeEditar
                            ? PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert, color: textColor),
                                onSelected: (value) {
                                  if (value == 'editar') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CriaMetodoPage(
                                          personalId: personalIds,
                                          metodo: metodo,
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
                                            'Tem certeza que deseja deletar o método "${metodo.nome}"?',
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Cancelar'),
                                              onPressed: () => Navigator.of(ctx).pop(),
                                            ),
                                            TextButton(
                                              child: const Text('Deletar', style: TextStyle(color: Colors.red)),
                                              onPressed: () {
                                                DaoMetodo.deletar(personalIds, metodo.id);
                                                Navigator.of(ctx).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                itemBuilder: (BuildContext context) => const [
                                  PopupMenuItem<String>(value: 'editar', child: Text('Editar')),
                                  PopupMenuItem<String>(value: 'deletar', child: Text('Deletar')),
                                ],
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
          if (podeEditar)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CriaMetodoPage(
                      personalId: personalIds,
                    ),
                  ),
                );
              },
              child: const Text(
                "+ Adicionar Método",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
