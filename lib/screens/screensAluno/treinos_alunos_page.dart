import 'package:flutter/material.dart';
import 'package:tcc/controllers/treino_controller.dart';
import 'package:tcc/models/treino.dart';
import 'package:tcc/screens/screensAluno/realizar_treinos_page.dart';

class ListaTreinosAlunoScreen extends StatelessWidget {
  final String alunoId;

  const ListaTreinosAlunoScreen({super.key, required this.alunoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Treino>>(
              stream: DaoTreino.getTreinosDoAluno(alunoId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                final treinos = snapshot.data ?? [];
                if (treinos.isEmpty) {
                  return const Center(
                      child: Text('Nenhum treino cadastrado.'));
                }

                return ListView.builder(
                  itemCount: treinos.length,
                  itemBuilder: (context, i) {
                    final t = treinos[i];
                    return Card(
                      color: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: ListTile(
                        title: Text(
                          t.nome,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Duração: ${t.duracao} | Feitos: ${t.feitos}/${t.duracao}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing:
                            const Icon(Icons.chevron_right, size: 28),
                        onTap: () {
                          if(t.feitos < t.duracao){
                            Navigator.push( // Navega para a lista de alunos do assistente
                              context,
                              MaterialPageRoute(
                                builder: (_) => RealizaTreinoPage(
                                  treino: t,
                                  personalId: t.personalId,
                                  alunoId: alunoId,
                                ), 
                              ),
                            );     
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Treino já concluído! Você atingiu a duração máxima do seu treino. Entre em contato com seu treinador.',
                                style: TextStyle(fontSize: 16),
                                ),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },                        
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
