import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc/models/mensagem.dart';
import 'package:tcc/models/feedback.dart';

class DaoChat {
  static final db = FirebaseFirestore.instance;

  static String _chatId(String id1, String id2) {
    final ids = [id1, id2]..sort();
    return ids.join('_');
  }

  static Stream<List<Mensagem>> streamMensagens(String alunoId, String personalId) {
    final chatId = _chatId(alunoId, personalId);
    return db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snap) {
          return snap.docs.map((d) => Mensagem.fromMap(d.data(), d.id)).toList();
        });
  }

  static Future<void> enviarMensagem(
      String remetenteId, String destinatarioId, String texto) async {
    final chatId = _chatId(remetenteId, destinatarioId);
    final msg = Mensagem(
      remetenteId: remetenteId,
      texto: texto,
      timestamp: DateTime.now(),
    );
    await db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(msg.toMap());
  }

  static Future<void> enviarFeedbackComoMensagem({
    required String chatId,
    required FeedbackModel feedback,
    required String treinoNome,
    required Map<String, String> exerciciosNomes, 
  }) async {
    try {
      final buffer = StringBuffer();
      buffer.writeln("📅 Treino: $treinoNome");
      buffer.writeln("🕒 ${feedback.data.day}/${feedback.data.month}/${feedback.data.year} - "
                     "${feedback.data.hour.toString().padLeft(2, '0')}:${feedback.data.minute.toString().padLeft(2, '0')}");
      buffer.writeln("\n🏋️‍♂️ Evolução:");

      feedback.cargas?.forEach((exercicioId, carga) {
        final nomeEx = exerciciosNomes[exercicioId] ?? "Exercício $exercicioId";
        final texto = feedback.textoFB?[exercicioId] ?? "";
        buffer.writeln("- $nomeEx: ${carga}kg ${texto.isNotEmpty ? "→ $texto" : ""}");
      });

      // if (feedback.videoFB != null && feedback.videoFB!.isNotEmpty) {
      //   buffer.writeln("\n🎥 Vídeo: ${feedback.videoFB}");
      // }

      final mensagem = buffer.toString();

      // Adiciona mensagem no chat
      await db.collection('chats').doc(chatId).collection('messages').add({
        'remetenteId': feedback.alunoId,
        'texto': mensagem,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'feedback',
      });

      print("✅ Feedback enviado como mensagem para o chat $chatId");
    } catch (e) {
      print("❌ Erro ao enviar feedback como mensagem: $e");
    }
  }

}
