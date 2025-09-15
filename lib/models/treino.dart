import 'package:tcc/models/item_treino.dart';

class Treino {
  final String id;
  final String nome;
  final int duracao;
  final String personalId;
  final List<ItemTreino> itens;
  final int feitos;


  Treino({
    required this.id,
    required this.nome,
    required this.personalId,
    required this.duracao,
    required this.itens,
    this.feitos = 0,
  });

  factory Treino.fromMap(Map<String, dynamic> map, String id) {
    final itensRaw = map['itens'];
  
    List<ItemTreino> itensConvertidos = [];

    if (itensRaw is List) {
      itensConvertidos = itensRaw
          .where((e) => e is Map<String, dynamic> && e['id'] != null && e['id'] is String)
          .map((e) => ItemTreino.fromMap(e as Map<String, dynamic>, e['id'] as String))
          .toList();
    }

    return Treino(
      id: id,
      nome: map['nome'] ?? '',
      duracao: map['duracao'] ?? 0,
      feitos: map['feitos'] ?? 0,
      personalId: map['personalId'] ?? '',
      itens: itensConvertidos,
    );
  }

  Map<String, dynamic> toMap() {
    return {
    'nome': nome,
    'duracao': duracao,
    'personalId': personalId,
    'feitos': feitos,
    'itens': itens.map((item) => item.toMap()).toList(),
    };
  }
}
