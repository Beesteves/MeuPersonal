import 'package:flutter/material.dart';
import 'package:tcc/controllers/exercicio_controller.dart';
import 'package:tcc/controllers/feedback_controller.dart';
import 'package:tcc/controllers/metodo_controller.dart';
import 'package:tcc/controllers/treino_controller.dart';
import 'package:tcc/models/exercicio.dart';
import 'package:tcc/models/feedback.dart';
import 'package:tcc/models/metodo.dart';
import 'package:tcc/models/treino.dart';
import 'package:tcc/screens/barra_cima_scaffold.dart';
import 'package:uuid/uuid.dart';

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

  // Map para guardar os dados inseridos pelo aluno (carga, mensagem, vídeo)
  final Map<String, TextEditingController> _cargaControllers = {};
  final Map<String, TextEditingController> _mensagemControllers = {};
  final Map<String, String?> _videoPaths = {}; // futuramente pode guardar link ou path

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

        // Inicializa os controladores para cada exercício
        for (var item in widget.treino.itens) {
          _cargaControllers[item.exercicioId] = TextEditingController();
          _mensagemControllers[item.exercicioId] = TextEditingController();
          _videoPaths[item.exercicioId] = null;
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados do treino: $e')),
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
    } catch (e) {
      return Colors.white;
    }
  }

  void _enviarDados() async {
  try {
    final Map<String, int> cargas = {};
    for (var item in widget.treino.itens) {
      final cargaTxt = _cargaControllers[item.exercicioId]?.text ?? '';
      final carga = int.tryParse(cargaTxt);
      if (carga != null) {
        cargas[item.exercicioId] = carga;
      }
    }

    final Map<String, String> mensagens = {};
    for (var item in widget.treino.itens) {
      final mensagemTxt = _mensagemControllers[item.exercicioId]?.text ?? '';
      if (mensagemTxt.isNotEmpty) {
        mensagens[item.exercicioId] = mensagemTxt;
      }
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

    // incrementa contador de treinos feitos
    await DaoTreino.adicionaTreinoFeito(widget.treino, widget.alunoId);

    // salva um NOVO feedback
    await DaoFeed.salvar(feedback);

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
                    'Duração: ${widget.treino.duracao} semanas ||  Feitos: ${widget.treino.feitos}/${widget.treino.duracao}',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  Text("Exercícios do Treino",
                      style: Theme.of(context).textTheme.titleLarge),
                  const Divider(height: 16),
                  if (widget.treino.itens.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("Este treino não possui exercícios."),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.treino.itens.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 0),
                      itemBuilder: (context, index) {
                        final item = widget.treino.itens[index];
                        final exercicio = _getExercicioPorId(item.exercicioId);
                        final metodo = _getMetodoPorId(item.metodoId);
                        final cardColor = _parseColor(metodo.cor);
                        final textColor = cardColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

                        return Card(
                          color: cardColor,
                          elevation: 2,
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          clipBehavior: Clip.antiAlias,
                          child: ExpansionTile(
                            iconColor: textColor,
                            collapsedIconColor: textColor,
                            title: Text(exercicio.nome,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Séries: ${item.numSerie} | Reps: ${item.numRepeticao}",
                                      style: TextStyle(color: textColor)),
                                  const SizedBox(height: 4),
                                  Text("Método: ${metodo.nome}",
                                      style: TextStyle(color: textColor)),
                                ],
                              ),
                            ),
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                    dividerColor: textColor.withOpacity(0.2)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0)
                                      .copyWith(top: 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Divider(),
                                      const SizedBox(height: 8),
                                      Text("Descrição do Exercício",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: textColor)),
                                      const SizedBox(height: 4),
                                      Text(
                                        exercicio.descricao.isNotEmpty
                                            ? exercicio.descricao
                                            : "Nenhuma descrição disponível.",
                                        style: TextStyle(color: textColor),
                                      ),
                                      const SizedBox(height: 16),
                                      Text("Vídeo Demonstrativo", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                                      const SizedBox(height: 8),
                                      // Placeholder para o player de vídeo.
                                      // Você pode substituir este Container por um widget de vídeo.
                                      Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: textColor.withOpacity(0.2)),
                                        ),
                                        child: Center(child: Icon(Icons.play_circle_outline, size: 60, color: textColor.withOpacity(0.7))),
                                      ),
                                      const SizedBox(height: 16),

                                      // Campo de carga
                                      TextField(
                                        controller: _cargaControllers[item.exercicioId],
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: "Carga realizada (kg)",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      // Campo de mensagem
                                      TextField(
                                        controller: _mensagemControllers[item.exercicioId],
                                        decoration: const InputDecoration(
                                          labelText: "Mensagem",
                                          border: OutlineInputBorder(),
                                        ),
                                        maxLines: 2,
                                      ),
                                      const SizedBox(height: 12),

                                      // Upload de vídeo (placeholder)
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          // aqui você pode abrir o picker de vídeo
                                          setState(() {
                                            _videoPaths[item.exercicioId] = "video_demo.mp4";
                                          });
                                        },
                                        icon: const Icon(Icons.video_call),
                                        label: Text(_videoPaths[item.exercicioId] == null
                                            ? "Selecionar vídeo"
                                            : "Vídeo selecionado"),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 24),

                  // Botão final de enviar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                      ),
                      onPressed: _enviarDados,
                      child: const Text("Enviar Treino", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
