import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FeedbackModel {
  final String id;
  final String alunoId;
  final String treinoId;
  final DateTime data;
  final Map<String, String>? textoFB;
  final String? videoFB;
  final Map<String, int>? cargas; // Map<idExercicio, carga>

  FeedbackModel({
    String? id,
    required this.alunoId,
    required this.treinoId,
    required this.data,
    this.textoFB,
    this.videoFB,
    this.cargas,
  }): id = id ?? const Uuid().v4(); 

  factory FeedbackModel.fromMap(Map<String, dynamic> map, String id) {
  DateTime data;
  if (map['data'] is Timestamp) {
    data = (map['data'] as Timestamp).toDate();
  } else if (map['data'] is String) {
    data = DateTime.tryParse(map['data']) ?? DateTime.now();
  } else if (map['data'] is DateTime) {
    data = map['data'];
  } else {
    data = DateTime.now();
  }

  return FeedbackModel(
    id: id,
    alunoId: map['alunoId'],
    treinoId: map['treinoId'],
    data: data,
    textoFB: map['textoFB'] != null
        ? Map<String, String>.from(map['textoFB'] as Map)
        : null,
    videoFB: map['videoFB'],
    cargas: map['cargas'] != null
        ? Map<String, int>.from(map['cargas'] as Map)
        : null,
  );
  }

  Map<String, dynamic> toMap() {
    return {
      'alunoId': alunoId,
      'treinoId': treinoId,
      'data': data.toIso8601String(),
      'cargas': cargas != null ? Map<String, dynamic>.from(cargas!) : null,
      'textoFB': textoFB != null ? Map<String, dynamic>.from(textoFB!) : null,
      'videoFB': videoFB,
    };
  }
}
