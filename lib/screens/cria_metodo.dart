import 'package:flutter/material.dart';
import 'package:tcc/controllers/metodo_controller.dart';
import 'package:tcc/models/metodo.dart';
import 'package:tcc/screens/barra_cima_scaffold.dart';

class CriaMetodoPage extends StatefulWidget {
  final String? personalId; 
  final Metodo? metodo;


  const CriaMetodoPage({
    super.key,
    this.metodo,
    this.personalId,
  });

  @override
  State<CriaMetodoPage> createState() => _CriaMetodoPageState();
}

class _CriaMetodoPageState extends State<CriaMetodoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();

  bool get _isEditing => widget.metodo != null;

  @override
  void initState() {
    _selectedColor = _predefinedColors[0];
    super.initState();
    if (_isEditing) {
      final e = widget.metodo!;
      _nomeController.text = e.nome;
      _descricaoController.text = e.descricao;
    }
  }

  final List<Color> _predefinedColors = [
    Colors.amber.shade300,
    Colors.blue.shade300,
    Colors.green.shade300,
    Colors.red.shade300,
    Colors.purple.shade300,
    Colors.orange.shade300,
    Colors.teal.shade300,
    Colors.pink.shade300,
  ];

  late Color _selectedColor;

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final novoMetodo = Metodo(
      id: _isEditing ? widget.metodo!.id : '',
      nome: _nomeController.text.trim(),
      descricao: _descricaoController.text.trim(),
      cor: _colorToHex(_selectedColor),
      personalId: widget.personalId!,
    );

    try {
      if(_isEditing){
        await DaoMetodo.editar(novoMetodo);
      } else{
        await DaoMetodo.salvar(novoMetodo);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Método salvo com sucesso!')));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao salvar dados: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BarraCimaScaffold(
      title: _isEditing ? "Editar Método" : "Novo Método",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: "Nome do método"),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Informe o nome do método" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: "descricao"),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? "Informe uma descricão" : null,
              ),
              const SizedBox(height: 20),
              const Text("Escolha uma cor para o método:",
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                alignment: WrapAlignment.center,
                children: _predefinedColors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColor == color
                              ? Colors.black
                              : Colors.transparent,
                          width: 3.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Criar",
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
