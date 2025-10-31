import 'package:flutter/material.dart';
import 'package:tcc/controllers/chat_controller.dart';
import 'package:tcc/controllers/exercicio_controller.dart';
import 'package:tcc/controllers/feedback_controller.dart';
import 'package:tcc/controllers/metodo_controller.dart';
import 'package:tcc/controllers/treino_controller.dart';
import 'package:tcc/controllers/usuario_controller.dart';
import 'package:tcc/models/exercicio.dart';
import 'package:tcc/models/feedback.dart';
import 'package:tcc/models/metodo.dart';
import 'package:tcc/models/treino.dart';
import 'package:tcc/screens/barra_cima_scaffold.dart';
import 'package:tcc/screens/video_exercicio_widget.dart';

class RealizaTreinoPage extends StatefulWidget {
  final Treino treino;
  final String alunoId;
  final String personalId;

  const RealizaTreinoPage({
    super.key,
    required this.treino,
    required this.alunoId,
    required this.personalId,
  });

  @override
  State<RealizaTreinoPage> createState() => _RealizaTreinoPageState();
}

class _RealizaTreinoPageState extends State<RealizaTreinoPage> {
  List<Exercicio> _exerciciosDisponiveis = [];
  List<Metodo> _metodosDisponiveis = [];
  bool _isLoading = true;

  final Map<String, TextEditingController> _cargaControllers = {};
  final Map<String, TextEditingController> _mensagemControllers = {};
  final Map<String, String?> _videoPaths = {};

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      final results = await Future.wait([
        DaoExercicio.getExerciciodoPersonal(widget.personalId).first,
        DaoMetodo.getMetodosDoPersonal(widget.personalId).first,
      ]);

      if (mounted) {
        setState(() {
          _exerciciosDisponiveis = results[0] as List<Exercicio>;
          _metodosDisponiveis = results[1] as List<Metodo>;
          _isLoading = false;
        });

        for (var item in widget.treino.itens) {
          _cargaControllers[item.exercicioId] = TextEditingController();
          _mensagemControllers[item.exercicioId] = TextEditingController();
          _videoPaths[item.exercicioId] = null;
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar treino: $e')),
        );
      }
    }
  }

  Exercicio _getExercicioPorId(String id) {
    return _exerciciosDisponiveis.firstWhere(
      (ex) => ex.id == id,
      orElse: () => Exercicio(
        id: '',
        nome: 'Exercício não encontrado',
        descricao: '',
        personalId: '',
      ),
    );
  }

  Metodo _getMetodoPorId(String id) {
    return _metodosDisponiveis.firstWhere(
      (m) => m.id == id,
      orElse: () => Metodo(
        id: '',
        nome: 'Método não encontrado',
        descricao: '',
        personalId: '',
        cor: '',
      ),
    );
  }

  Color _parseColor(String colorString) {
    if (colorString.isEmpty) return Colors.white;
    try {
      final hexCode = colorString.replaceAll('#', '');
      final fullHexCode = hexCode.length == 6 ? 'ff$hexCode' : hexCode;
      return Color(int.parse('0x$fullHexCode'));
    } catch (_) {
      return Colors.white;
    }
  }

  Future<void> _enviarDados() async {
    try {
      final Map<String, int> cargas = {};
      final Map<String, String> mensagens = {};

      for (var item in widget.treino.itens) {
        final carga = int.tryParse(_cargaControllers[item.exercicioId]?.text ?? '');
        if (carga != null) cargas[item.exercicioId] = carga;

        final msg = _mensagemControllers[item.exercicioId]?.text ?? '';
        if (msg.isNotEmpty) mensagens[item.exercicioId] = msg;
      }

      final primeiroVideo = _videoPaths.values.firstWhere(
        (v) => v != null,
        orElse: () => null,
      );

      final feedback = FeedbackModel(
        alunoId: widget.alunoId,
        treinoId: widget.treino.id,
        data: DateTime.now(),
        textoFB: mensagens.isNotEmpty ? mensagens : null,
        videoFB: primeiroVideo,
        cargas: cargas.isNotEmpty ? cargas : null,
      );

      await DaoTreino.adicionaTreinoFeito(widget.treino, widget.alunoId);
      await DaoFeed.salvar(feedback);

      await DaoChat.enviarFeedbackComoMensagem(
        chatId: "${widget.alunoId}_${widget.personalId}",
        feedback: feedback,
        treinoNome: widget.treino.nome,
        exerciciosNomes: {
          for (var item in widget.treino.itens)
            item.exercicioId: _getExercicioPorId(item.exercicioId).nome,
        },
      );

      final aluno = await DaoUser.getUsuarioById(widget.alunoId);
      if (aluno?.assistenteId != null) {
        await DaoChat.enviarFeedbackComoMensagem(
          chatId: "${widget.alunoId}_${aluno!.assistenteId!}",
          feedback: feedback,
          treinoNome: widget.treino.nome,
          exerciciosNomes: {
            for (var item in widget.treino.itens)
              item.exercicioId: _getExercicioPorId(item.exercicioId).nome,
          },
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Feedback enviado com sucesso!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao enviar feedback: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BarraCimaScaffold(
      title: widget.treino.nome,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Duração: ${widget.treino.duracao} semanas  |  Feitos: ${widget.treino.feitos}/${widget.treino.duracao}',
                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  Text("Exercícios do Treino", style: theme.textTheme.titleLarge),
                  const Divider(height: 16),

                  if (widget.treino.itens.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("Este treino não possui exercícios."),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.treino.itens.length,
                      itemBuilder: (context, index) {
                        final item = widget.treino.itens[index];
                        final exercicio = _getExercicioPorId(item.exercicioId);
                        final metodo = _getMetodoPorId(item.metodoId);
                        final cardColor = _parseColor(metodo.cor);
                        final textColor = cardColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Theme(
                              data: theme.copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                collapsedBackgroundColor: Colors.transparent,
                                backgroundColor: Colors.transparent,
                                iconColor: textColor,
                                collapsedIconColor: textColor,
                                title: Text(
                                  exercicio.nome,
                                  style: theme.textTheme.titleLarge?.copyWith(color: textColor),
                                ),
                                subtitle: Text(
                                  "Séries: ${item.numSerie} | Reps: ${item.numRepeticao}\nMétodo: ${metodo.nome}",
                                  style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Descrição do Exercício",
                                            style: theme.textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold, color: textColor)),
                                        const SizedBox(height: 4),
                                        Text(
                                          exercicio.descricao.isNotEmpty
                                              ? exercicio.descricao
                                              : "Nenhuma descrição disponível.",
                                          style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
                                        ),

                                        if (exercicio.video != null && exercicio.video!.isNotEmpty) ...[
                                          const SizedBox(height: 16),
                                          Text("Vídeo Demonstrativo",
                                              style: theme.textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.bold, color: textColor)),
                                          const SizedBox(height: 8),
                                          VideoExercicioWidget(url: exercicio.video!, textColor: textColor),
                                        ],

                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: _cargaControllers[item.exercicioId],
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            labelText: "Carga realizada (kg)",
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        TextField(
                                          controller: _mensagemControllers[item.exercicioId],
                                          decoration: const InputDecoration(labelText: "Mensagem"),
                                          maxLines: 2,
                                        ),
                                        const SizedBox(height: 12),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _enviarDados,
                      icon: const Icon(Icons.send),
                      label: const Text("Enviar Treino"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
