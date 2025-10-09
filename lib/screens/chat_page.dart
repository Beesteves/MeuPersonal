import 'package:flutter/material.dart';
import 'package:tcc/controllers/chat_controller.dart';
import 'package:tcc/models/mensagem.dart';
import 'package:tcc/models/usuario.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final Usuario contato;

  const ChatPage({super.key, required this.userId, required this.contato});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.contato.nome)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Mensagem>>(
              stream: DaoChat.streamMensagens(widget.userId, widget.contato.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Nenhuma mensagem"));
                }

                final mensagens = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: mensagens.length,
                  itemBuilder: (context, index) {
                    final msg = mensagens[index];
                    final isMe = msg.remetenteId == widget.userId;
                 
                    final isFeedback = msg.tipo == 'feedback';

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: isFeedback
                              ? Colors.green[100]
                              : isMe ? Colors.blue[200] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                          border: isFeedback
                              ? Border.all(color: Colors.green, width: 1)
                              : null,
                        ),
                        child: isFeedback
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.assignment_outlined,
                                  color: Colors.green, size: 20),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Relatório de Treino",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    msg.texto,
                                    style: const TextStyle(height: 1.4),
                                  ),
                                ],
                              )
                            :Text(msg.texto),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Digite sua mensagem...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      DaoChat.enviarMensagem(
                        widget.userId,
                        widget.contato.id,
                        _controller.text.trim(),
                      );
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
