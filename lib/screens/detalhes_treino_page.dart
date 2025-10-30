import 'package:flutter/material.dart';
import 'package:tcc/controllers/exercicio_controller.dart';
import 'package:tcc/controllers/metodo_controller.dart';
import 'package:tcc/models/exercicio.dart';
import 'package:tcc/models/metodo.dart';
import 'package:tcc/models/treino.dart';
import 'package:tcc/screens/barra_cima_scaffold.dart';
import 'package:tcc/screens/video_exercicio_widget.dart';

class DetalhesTreinoPage extends StatefulWidget {
  final Treino treino;
  final String personalId;

  const DetalhesTreinoPage({
    super.key,
    required this.treino,
    required this.personalId,
  });

  @override
  State<DetalhesTreinoPage> createState() => _DetalhesTreinoPageState();
}

class _DetalhesTreinoPageState extends State<DetalhesTreinoPage> {
  List<Exercicio> _exerciciosDisponiveis = [];
  List<Metodo> _metodosDisponiveis = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      // Carrega exercícios e métodos em paralelo para mais performance
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
      orElse: () => Exercicio(id: '', nome: 'Exercício não encontrado', descricao: '', personalId: ''),
    );
  }

  Metodo _getMetodoPorId(String id) {
    return _metodosDisponiveis.firstWhere(
      (m) => m.id == id,
      orElse: () => Metodo(id: '', nome: 'Método não encontrado', descricao: '', personalId: '', cor: ''),
    );
  }

  Color _parseColor(String colorString) {
    // Retorna branco se a string for nula, vazia ou inválida
    if (colorString.isEmpty) {
      return Colors.white;
    }
    try {
      final hexCode = colorString.replaceAll('#', '');
      // Adiciona 'ff' para opacidade total se não estiver presente
      final fullHexCode = hexCode.length == 6 ? 'ff$hexCode' : hexCode;
      return Color(int.parse('0x$fullHexCode'));
    } catch (e) {
      return Colors.white; // Cor padrão em caso de erro
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
                    'Duração: ${widget.treino.duracao} semanas',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  Text("Exercícios do Treino", style: Theme.of(context).textTheme.titleLarge),
                  const Divider(height: 16),
                  if (widget.treino.itens.isEmpty)
                    const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text("Este treino não possui exercícios.")))
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.treino.itens.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 0),
                      itemBuilder: (context, index) {
                        final item = widget.treino.itens[index];
                        final exercicio = _getExercicioPorId(item.exercicioId);
                        final metodo = _getMetodoPorId(item.metodoId);
                        final cardColor = _parseColor(metodo.cor);
                        final textColor = cardColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

                        return Card(
                          color: cardColor,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          clipBehavior: Clip.antiAlias,
                          child: ExpansionTile(
                            iconColor: textColor,
                            collapsedIconColor: textColor,
                            title: Text(exercicio.nome, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Séries: ${item.numSerie} | Reps: ${item.numRepeticao}", style: TextStyle(color: textColor)),
                                  const SizedBox(height: 4),
                                  Text("Método: ${metodo.nome}", style: TextStyle(color: textColor)),
                                ],
                              ),
                            ),
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(dividerColor: textColor.withOpacity(0.2)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0).copyWith(top: 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Divider(),
                                      const SizedBox(height: 8),
                                      Text("Descrição do Exercício", style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                                      const SizedBox(height: 4),
                                      Text(
                                        exercicio.descricao.isNotEmpty ? exercicio.descricao : "Nenhuma descrição disponível.",
                                        style: TextStyle(color: textColor),
                                      ),
                                      if(exercicio.video != null && exercicio.video!.isNotEmpty) ...[
                                        const SizedBox(height: 16),
                                        Text(
                                          "Vídeo Demonstrativo",
                                          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
                                        ),
                                        const SizedBox(height: 8),
                                        VideoExercicioWidget(
                                          url: exercicio.video!,
                                          textColor: textColor,
                                        ),                                      
                                      ],                                        
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }
}
