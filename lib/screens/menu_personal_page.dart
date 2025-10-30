import 'package:flutter/material.dart';
import 'package:tcc/screens/assistente_page.dart';
import 'package:tcc/screens/exercicios_page.dart';
import 'package:tcc/screens/metodo_page.dart';
import 'package:tcc/screens/treino_page.dart';
import 'package:tcc/screens/perfil.dart';

class MenuPagePersonal extends StatelessWidget {
  final String personalIds;
  final String userTipo; // 'personal' ou 'assistente'

  const MenuPagePersonal({
    required this.personalIds,
    required this.userTipo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(20),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        _buildMenuButton(
          icon: Icons.fitness_center,
          label: 'Treinos',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ListaTreinosPage(
                  personalId: personalIds,
                  userTipo: userTipo,
                ),
              ),
            );
          },
        ),
        _buildMenuButton(
          icon: Icons.fitness_center,
          label: 'Exercícios',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ListaExerciciosPage(
                  userTipo: userTipo,
                  personalId: personalIds,
                ),
              ),
            );
          },
        ),
        _buildMenuButton(
          icon: Icons.account_tree,
          label: 'Métodos',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ListaMetodosScreen(
                  personalIds: personalIds, 
                  userTipo: userTipo,
                ),
              ),
            );
          },
        ),

        // Botão Assistente só aparece se for personal
        if (userTipo == 'personal')
          _buildMenuButton(
            icon: Icons.accessibility,
            label: 'Assistente',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ListaAssistentesScreen(
                    personalIds: personalIds,
                  ),
                ),
              );
            },
          ),

        // Botão Perfil só aparece se for assistente
        if (userTipo == 'assistente')
          _buildMenuButton(
            icon: Icons.person,
            label: 'Perfil',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PerfilPage(),
                ),
              );
            },
          ),
      ],
    );
  }

  static Widget _buildMenuButton({
    required IconData icon,
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
            Icon(icon, size: 48, color: Colors.black),
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
