import 'package:flutter/material.dart';
import 'package:tcc/controllers/exercicio_controller.dart';
import 'package:tcc/controllers/metodo_controller.dart';
import 'package:tcc/controllers/treino_controller.dart';
import 'package:tcc/models/exercicio.dart';
import 'package:tcc/models/item_treino.dart';
import 'package:tcc/models/metodo.dart';
import 'package:tcc/models/treino.dart';
import 'package:tcc/screens/barra_cima_scaffold.dart';

class CriaTreinoPage extends StatefulWidget {
  final String personalId;
  final Treino? treino; // Se for nulo, é criação. Se não, é edição.

  const CriaTreinoPage({
    super.key,
    required this.personalId,
    this.treino,
  });

  @override
  State<CriaTreinoPage> createState() => _CriaTreinoPageState();
}

class _CriaTreinoPageState extends State<CriaTreinoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _duracaoController = TextEditingController();
  
  final List<ItemTreino> _itensTreino = [];
  List<Exercicio> _exerciciosDisponiveis = [];
  List<Metodo> _metodosDisponiveis = [];


  bool get _isEditing => widget.treino != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final t = widget.treino!;
      _nomeController.text = t.nome;
      _duracaoController.text = t.duracao.toString();
      setState(() {
        _itensTreino.addAll(t.itens);
      });
    }
    _carregarExercicios();
    _carregarMetodos();
  }

  Future<void> _carregarExercicios() async {
    final exercicios = await DaoExercicio.getExerciciodoPersonal(widget.personalId).first;
    if (mounted) {
      setState(() {
        _exerciciosDisponiveis = exercicios;
      });
    }
  }

  Future<void> _carregarMetodos() async {
    final metodos = await DaoMetodo.getMetodosDoPersonal(widget.personalId).first;
    if (mounted) {
      setState(() {
        _metodosDisponiveis = metodos;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_itensTreino.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adicione pelo menos um exercício ao treino.')));
      return;
    }

    final treinoData = Treino(
      id: _isEditing ? widget.treino!.id : '',
      nome: _nomeController.text.trim(),
      duracao: int.tryParse(_duracaoController.text.trim()) ?? 0,
      personalId: widget.personalId,
      itens: _itensTreino,
    );

    try {
      if (_isEditing) {
        await DaoTreino.editar(treinoData);
      } else {
        await DaoTreino.salvar(treinoData);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Treino salvo com sucesso!')));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao salvar dados: $e')));
    }
  }

  void _mostrarDialogAdicionarItem() {
    showDialog(
      context: context,
      builder: (context) {
        String? exercicioIdSelecionado;
        String? metodoIdSelecionado;
        String? tipoFiltro;
        final seriesController = TextEditingController();
        final repeticoesController = TextEditingController();
        final formKeyDialog = GlobalKey<FormState>();

        final tipos = _exerciciosDisponiveis
          .map((e) => e.tipo?.trim() ?? '')
          .where((t) => t.isNotEmpty)
          .toSet()
          .toList()
          ..sort();


        return StatefulBuilder(
          builder: (context, setDialogState) {
            final exerciciosFiltrados = tipoFiltro == null
              ? _exerciciosDisponiveis
              : _exerciciosDisponiveis
                .where((e) => (e.tipo ?? '').toLowerCase() == tipoFiltro!.toLowerCase())
                .toList();

            return AlertDialog(
              title: const Text("Adicionar Exercício ao Treino"),
              content: Form(
                key: formKeyDialog,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(tipos.isNotEmpty)
                        DropdownButtonFormField<String>(
                          value: tipoFiltro,
                          hint: const Text("Filtrar por tipo (opcional)"),
                          items: [null, ...tipos]
                            .map((tipo) {
                              return DropdownMenuItem<String>(
                                value: tipo,
                                child: Text(tipo ?? "Todos"),
                              );
                              })
                            .toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              tipoFiltro = value;
                              exercicioIdSelecionado = null;
                            });
                          },
                        ),
                      const SizedBox(height: 8),

                      if (exerciciosFiltrados.isEmpty)
                        const Text("Nenhum exercício disponível para este tipo.")
                      else
                        DropdownButtonFormField<String>(
                          value: exercicioIdSelecionado,
                          hint: const Text("Selecione um Exercício"),
                          items: exerciciosFiltrados.map((exercicio) {
                            return DropdownMenuItem(
                              value: exercicio.id,
                              child: Text(exercicio.nome),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              exercicioIdSelecionado = value;
                            });
                          },
                          validator: (v) => v == null ? "Selecione um exercício" : null,
                        ),
                      if (_metodosDisponiveis.isEmpty)
                        const Text("Nenhum método disponível. Crie um método primeiro.")
                      else
                        DropdownButtonFormField<String>(
                          value: metodoIdSelecionado,
                          hint: const Text("Selecione um Método"),
                          items: _metodosDisponiveis.map((metodo) {
                            return DropdownMenuItem(
                              value: metodo.id,
                              child: Text(metodo.nome),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              metodoIdSelecionado = value;
                            });
                          },
                          validator: (v) => v == null ? "Selecione um método" : null,
                        ),                          
                      TextFormField(
                        controller: seriesController,
                        decoration: const InputDecoration(labelText: "Nº de Séries"),
                        keyboardType: TextInputType.number,
                        validator: (v) => (v == null || v.trim().isEmpty) ? "Informe as séries" : null,
                      ),
                      TextFormField(
                        controller: repeticoesController,
                        decoration: const InputDecoration(labelText: "Nº de Repetições"),
                        keyboardType: TextInputType.number,
                        validator: (v) => (v == null || v.trim().isEmpty) ? "Informe as repetições" : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKeyDialog.currentState!.validate()) {
                      final novoItem = ItemTreino(
                        id: exercicioIdSelecionado!, // O id do item será o id do exercício
                        exercicioId: exercicioIdSelecionado!,
                        metodoId: metodoIdSelecionado!,
                        numSerie: int.parse(seriesController.text),
                        numRepeticao: int.parse(repeticoesController.text),
                      );

                      if (_itensTreino.any((item) => item.exercicioId == novoItem.exercicioId)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Este exercício já foi adicionado.'))
                        );
                        return;
                      }

                      setState(() {
                        _itensTreino.add(novoItem);
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Adicionar"),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BarraCimaScaffold(
      title: _isEditing ? "Editar Treino" : "Novo Treino",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome do Treino"),
                validator: (v) => (v == null || v.trim().isEmpty) ? "Informe o nome" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _duracaoController,
                decoration: const InputDecoration(labelText: "Duração (semanas)"),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || v.trim().isEmpty) ? "Informe a duração" : null,
              ),
              const SizedBox(height: 24),
              Text("Exercícios do Treino", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              _itensTreino.isEmpty
                ? const Center(child: Padding(padding: EdgeInsets.all(8.0), child: Text("Nenhum exercício adicionado.")))
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _itensTreino.length,
                  itemBuilder: (context, index) {
                    final item = _itensTreino[index];
                    final exercicio = _exerciciosDisponiveis.firstWhere(
                      (ex) => ex.id == item.exercicioId,
                      orElse: () => Exercicio(id: '', nome: 'Exercício não encontrado', descricao: '', personalId: ''),
                    );
                    final metodo = _metodosDisponiveis.firstWhere(
                      (m) => m.id == item.metodoId,
                      orElse: () => Metodo(id: '', nome: 'Não encontrado', descricao: '', personalId: '', cor: ''),
                    );
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(exercicio.nome),
                        subtitle: Text(
                            "Séries: ${item.numSerie}, Reps: ${item.numRepeticao}, Método: ${metodo.nome}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _itensTreino.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 12),
              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Adicionar Exercício ao Treino"),
                  onPressed: _mostrarDialogAdicionarItem,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _isEditing ? "Salvar Alterações" : "Salvar Treino",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
