import 'package:tcc/models/item_treino.dart';

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
    final itensRaw = map['itens'];
  
    List<ItemTreino> itensConvertidos = [];

    if (itensRaw is List) {
      itensConvertidos = itensRaw
          .where((e) => e is Map<String, dynamic> && e['id'] != null)
          .map((e) => ItemTreino.fromMap(e as Map<String, dynamic>, e['id'] as String))
          .toList();
    }

    return Treino(
      id: id,
      nome: map['nome'] ?? '',
      duracao: map['duracao'] ?? '',
      itens: itensConvertidos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
    'nome': nome,
    'duracao': duracao,
    'itens': itens.map((item) {
      final itemMap = item.toMap();
      itemMap['id'] = item.id;
      return itemMap;
    }).toList(),
    };
  }
}
