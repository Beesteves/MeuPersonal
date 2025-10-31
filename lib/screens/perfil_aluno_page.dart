import 'package:flutter/material.dart';
import 'package:tcc/controllers/treino_controller.dart';
import 'package:tcc/controllers/usuario_controller.dart';
import 'package:tcc/models/treino.dart';
import 'package:tcc/models/usuario.dart';
import 'package:tcc/screens/barra_cima_scaffold.dart';
import 'package:tcc/screens/cria_treino_page.dart';
import 'package:tcc/screens/detalhes_treino_page.dart';

class AlunoPerfilPage extends StatelessWidget {
  final String alunoId;
  final String personalId;


  const AlunoPerfilPage({super.key, required this.alunoId, required this.personalId});

  Future<Map<String, dynamic>> _getDados() async {
    try {
      // Busca dados do aluno e seus treinos em paralelo
      final results = await Future.wait([
        DaoUser.streamUsuarioById(alunoId).first,
        DaoTreino.getTreinosDoAluno(alunoId).first,
      ]);

      final aluno = results[0] as Usuario;
      final treinos = results[1] as List<Treino>;

      return {'aluno': aluno, 'treinos': treinos};
    } catch (e) {
      print('Erro ao buscar dados do perfil: $e');
      rethrow; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getDados(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const BarraCimaScaffold(
            title: "Carregando...",
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return BarraCimaScaffold(
            title: "Erro",
            body: Center(
                child: Text(snapshot.error?.toString() ??
                    "Aluno ou treinos não encontrados")),
          );
        }

        final aluno = snapshot.data!['aluno'] as Usuario;
        final treinos = snapshot.data!['treinos'] as List<Treino>;

        return BarraCimaScaffold(
          title: aluno.nome,
          body: _AlunoPerfilBody(aluno: aluno, treinos: treinos),
        );
      },
    );
  }
}

class _AlunoPerfilBody extends StatelessWidget {
  const _AlunoPerfilBody({required this.aluno, required this.treinos});

  final Usuario aluno;
  final List<Treino> treinos;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InformacoesAluno(aluno: aluno),
          const SizedBox(height: 30),
          _BotoesAcao(aluno: aluno),
          const SizedBox(height: 30),
          _ListaDeTreinos(
            treinos: treinos,
            personalId: aluno.personalId!,
            aluno: aluno,
          ),
        ],
      ),
    );
  }
}

class _InformacoesAluno extends StatelessWidget {
  const _InformacoesAluno({required this.aluno});

  final Usuario aluno;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        if (aluno.assistenteId != null && aluno.assistenteId!.isNotEmpty)
          FutureBuilder<Usuario>(
              future: DaoUser.streamUsuarioById(aluno.assistenteId!).first.then((value) => value!),
              builder: (context, snapshot) {
                return Text("Assistente: ${snapshot.data?.nome ?? 'Carregando...'}    Início Acompanhamento: ${aluno.criadoEm.day.toString().padLeft(2, '0')}/${aluno.criadoEm.month.toString().padLeft(2, '0')}/${aluno.criadoEm.year}",
                    style: Theme.of(context).textTheme.bodyLarge);
              }),
      ],
    );
  }
}

class _BotoesAcao extends StatelessWidget {
  const _BotoesAcao({required this.aluno});

  final Usuario aluno;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.fitness_center),
            label: const Text("Adicionar Treino"),
            onPressed: () {
              _showOpcoesAdicionarTreino(context, aluno, aluno.personalId!);
            },
            // Estilo herdado do ElevatedButtonTheme
          ),
        ),
        const SizedBox(height: 10),
        if (aluno.personalId != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.group_add),
              label: const Text("Adicionar Assistente"),
              onPressed: () {
                // Abre um diálogo para selecionar um assistente existente
                _showDialogoSelecaoAssistente(context, aluno);
              },
              // Estilo herdado do ElevatedButtonTheme
            ),
          ),
      ],
    );
  }
}

class _ListaDeTreinos extends StatelessWidget {
  final List<Treino> treinos;
  final String personalId;
  final Usuario aluno;

  const _ListaDeTreinos({required this.treinos, required this.personalId, required this.aluno});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Treinos Atribuídos",
            style: Theme.of(context).textTheme.titleLarge),
        const Divider(height: 16),
        if (treinos.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Text("Nenhum treino atribuído a este aluno."),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: treinos.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final treino = treinos[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  title: Text(treino.nome,
                      style: Theme.of(context).textTheme.titleMedium),
                  subtitle: Text(
                    "Duração: ${treino.duracao} semanas   Realizados: ${treino.feitos}\n"
                    "Status: ${treino.status}"),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value){
                      if (value == 'deletar'){
                        DaoTreino.desatribuir(treino.id, aluno.id);
                      }
                      else if (value == 'bloquear'){
                        DaoTreino.bloquear(treino, aluno.id);
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                      const <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'deletar', child: Text('Deletar')),
                        PopupMenuItem<String>(
                          value: 'bloquear', child: Text('Bloquear')),
                      ]
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesTreinoPage(
                          treino: treino,
                          personalId: personalId,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}

/// Mostra um menu de opções para adicionar um treino.
void _showOpcoesAdicionarTreino(
    BuildContext context, Usuario aluno, String personalId) {
  showModalBottomSheet(
    context: context,
    builder: (ctx) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Criar novo treino do zero'),
              onTap: () {
                Navigator.pop(ctx); // Fecha o BottomSheet
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CriaTreinoPage(personalId: personalId),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.content_copy),
              title: const Text('Usar modelo de treino existente'),
              onTap: () {
                Navigator.pop(ctx); // Fecha o BottomSheet
                _showDialogoSelecaoModelo(context, aluno, personalId);
              },
            ),
          ],
        ),
      );
    },
  );
}


/// Mostra um diálogo para selecionar um assistente e atribuí-lo ao aluno.
void _showDialogoSelecaoAssistente(BuildContext context, Usuario aluno) {
  if (aluno.personalId == null || aluno.personalId!.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Erro: Aluno não está vinculado a um personal.')),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return FutureBuilder<List<Usuario>>(
        // Busca todos os usuários do tipo 'assistente' vinculados ao mesmo personal
        future: DaoUser.getAssistentesDoPersonal(aluno.personalId!).first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AlertDialog(
              title: Text('Selecionar Assistente'),
              content: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return AlertDialog(
              title: const Text('Erro'),
              content:
                  const Text('Não foi possível carregar os assistentes.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Fechar'),
                ),
              ],
            );
          }

          final assistentes = snapshot.data!;

          if (assistentes.isEmpty) {
            return AlertDialog(
              title: const Text('Selecionar Assistente'),
              content: const Text(
                  'Nenhum assistente cadastrado para este personal.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Fechar'),
                ),
              ],
            );
          }

          return AlertDialog(
            title: const Text('Selecionar Assistente'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: assistentes.length,
                itemBuilder: (context, index) {
                  final assistente = assistentes[index];
                  return ListTile(
                    title: Text(assistente.nome),
                    onTap: () async {
                      try {
                        await DaoUser.definirAssistenteParaAluno(
                            aluno.id, assistente.id);
                        Navigator.pop(dialogContext); // Fecha o diálogo
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Assistente "${assistente.nome}" atribuído com sucesso!')),
                        );
                        // Recarrega a página para mostrar o novo assistente
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlunoPerfilPage(
                                    alunoId: aluno.id,
                                    personalId: aluno.personalId!)));
                      } catch (e) {
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Erro ao atribuir assistente: $e')));
                      }
                    },
                  );
                },
              ),
            ),
          );
        },
      );
    },
  );
}

void _showDialogoSelecaoModelo(
  BuildContext context,
  Usuario aluno,
  String personalId,
) {
  if (aluno.personalId == null || aluno.personalId!.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erro: Aluno não está vinculado a um personal.')),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return StreamBuilder<List<Treino>>(
        stream: DaoTreino.getTreinosDoPersonal(personalId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AlertDialog(
              title: Text('Selecionar Modelo'),
              content: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return AlertDialog(
              title: const Text('Erro'),
              content: Text('Falha ao carregar modelos: ${snapshot.error}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Fechar'),
                ),
              ],
            );
          }

          final modelos = snapshot.data ?? [];
          if (modelos.isEmpty) {
            return AlertDialog(
              title: const Text('Selecionar Modelo'),
              content: const Text(
                'Nenhum modelo de treino encontrado. '
                'Crie um treino na coleção "treinos" do personal para usá-lo como modelo.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Fechar'),
                ),
              ],
            );
          }

          return AlertDialog(
            title: const Text('Selecionar Modelo de Treino'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: modelos.length,
                itemBuilder: (context, index) {
                  final modelo = modelos[index];
                  return ListTile(
                    title: Text(modelo.nome),
                    // ignore: unnecessary_null_comparison
                    subtitle: modelo.duracao != null
                        ? Text('Duração: ${modelo.duracao} semanas')
                        : null,
                    onTap: () async {
                      try {
                        modelo.data = DateTime.now();
                        await DaoTreino.atribuirTreino(modelo, aluno.id);
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Treino "${modelo.nome}" atribuído!')),
                        );
                        // Se quiser atualizar a tela atual, use setState/Stream no perfil
                      } catch (e) {
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao atribuir treino: $e')),
                        );
                      }
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancelar'),
              ),
            ],
          );
        },
      );
    },
  );
}
