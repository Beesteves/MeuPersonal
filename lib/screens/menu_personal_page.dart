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
    super.key,
  });

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
          context,
          icon: Icons.assignment,
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
          context,
          icon: Icons.sports_gymnastics,
          label: 'Exercícios',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ListaExerciciosPage(                  
                  personalId: personalIds,
                  userTipo: userTipo,
                ),
              ),
            );
          },
        ),
        _buildMenuButton(
          context,
          icon: Icons.mediation,
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
            context,
            icon: Icons.support_agent,
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
            context,
            icon: Icons.account_circle,
            label: 'Perfil',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PerfilPage(),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.onSurfaceVariant),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(label, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ),
          ],
        ),
      ),
    );
  }
}
