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
    return FeedbackModel(
      id: id,
      alunoId: map['alunoId'],
      treinoId: map['treinoId'],
      data: map['data'] is Timestamp    ? (map['data'] as Timestamp).toDate()    : map['data'],
      textoFB: Map<String, String>.from(map['textoFB']),
      videoFB: map['videoFB'],
      cargas: Map<String, int>.from(map['cargas']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alunoId': alunoId,
      'treinoId': treinoId,
      'data': data,
      'textoFB': textoFB,
      'videoFB': videoFB,
      'cargas': cargas,
    };
  }
}
