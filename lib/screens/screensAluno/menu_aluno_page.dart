import 'package:flutter/material.dart';
import 'package:tcc/controllers/usuario_controller.dart';
import 'package:tcc/models/usuario.dart';
import 'package:tcc/screens/evolucao_page.dart';
import 'package:tcc/screens/perfil.dart';

class MenuPageAluno extends StatelessWidget {
  final String alunoId;

  const MenuPageAluno({super.key, required this.alunoId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Usuario?>(
      future: DaoUser.getUsuarioById(alunoId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Erro: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("Aluno não encontrado"));
        }

        final aluno = snapshot.data!; 

        return GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(20),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            _buildMenuButton(
              icon: Icons.show_chart,
              label: 'Evolução',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExerciciosScreen(
                      personalId: aluno.personalId ?? "", 
                      alunoId: alunoId,
                    ),
                  ),
                );
              },
            ),
            _buildMenuButton(
              icon: Icons.person,
              label: 'Perfil',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PerfilPage()
                    ),
                );
              },
            ),
            // _buildMenuButton(
            //   icon: null,
            //   label: '',
            //   onTap: () {},
            // ),
            // _buildMenuButton(
            //   icon: null,
            //   label: '',
            //   onTap: () {},
            // ),
          ],
        );
      },
    );
  }

  static Widget _buildMenuButton({
    required IconData? icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(icon, size: 48, color: Colors.black),
            if (label.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
