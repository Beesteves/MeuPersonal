import 'package:flutter/material.dart';

class MenuPageAluno extends StatelessWidget {
  const MenuPageAluno({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(20),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: [
        _buildMenuButton(
          icon: Icons.show_chart,
          label: 'Evolução',
          onTap: () {},
        ),
        _buildMenuButton(
          icon: null,
          label: '',
          onTap: () {},
        ),
        _buildMenuButton(
          icon: Icons.person,
          label: 'Perfil',
          onTap: () {},
        ),
        _buildMenuButton(
          icon: null,
          label: '',
          onTap: () {},
        ),
      ],
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
