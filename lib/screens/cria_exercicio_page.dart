import 'package:flutter/material.dart';
import 'package:tcc/controllers/exercicio_controller.dart';
import 'package:tcc/models/exercicio.dart';
import 'package:tcc/screens/barra_cima_scaffold.dart';

class CriaExercicioPage extends StatefulWidget {
  final String personalId;
  final Exercicio? exercicio; // Se for nulo, é criação. Se não, é edição.

  const CriaExercicioPage({
    super.key,
    required this.personalId,
    this.exercicio,
  });

  @override
  State<CriaExercicioPage> createState() => _CriaExercicioPageState();
}

class _CriaExercicioPageState extends State<CriaExercicioPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _tipoController = TextEditingController();
  final _videoController = TextEditingController();

  bool get _isEditing => widget.exercicio != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final e = widget.exercicio!;
      _nomeController.text = e.nome;
      _descricaoController.text = e.descricao;
      _tipoController.text = e.tipo ?? '';
      _videoController.text = e.video ?? '';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final exercicioData = Exercicio(
      id: _isEditing ? widget.exercicio!.id : '',
      nome: _nomeController.text.trim(),
      descricao: _descricaoController.text.trim(),
      tipo: _tipoController.text.trim(),
      video: _videoController.text.trim(),
      personalId: widget.personalId,

    );

    try {
      if (_isEditing) {
        await DaoExercicio.editar(exercicioData);
      } else {
        await DaoExercicio.salvar(exercicioData);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exercício salvo com sucesso!')));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao salvar dados: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BarraCimaScaffold(
      title: _isEditing ? "Editar Exercício" : "Novo Exercício",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome do Exercício"),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Informe o nome" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: "Descrição (Ex: Equipamento, postura)"),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Informe uma descrição" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(

                controller: _tipoController,
                decoration: const InputDecoration(labelText: "Tipo (Ex: Força, Cardio, Flexibilidade)"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _videoController,
                decoration: const InputDecoration(labelText: "Link do Vídeo (Opcional)"),
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
                  child: const Text(
                    "Salvar Exercício",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
