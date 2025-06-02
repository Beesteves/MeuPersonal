import 'package:tcc/models/itemTreino.dart';

class Treino {
  final String id;
  final String nome;
  final int duracao;
  final List<ItemTreino> itens;


  Treino({
    required this.id,
    required this.nome,
    required this.duracao,
    required this.itens,
  });

  factory Treino.fromMap(Map<String, dynamic> map, String id) {
    return Treino(
      id: id,
      nome: map['nome'],
      duracao: map['duracao'],
      itens: (map['itens'] as List).map((e) => ItemTreino.fromMap(e)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'duracao': duracao,
      'itens': itens.map((e) => e.toMap()).toList(),
    };
  }
}
