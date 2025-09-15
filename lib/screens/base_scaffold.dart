import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const BaseScaffold({
    super.key,
    required this.title,
    required this.body,
    required this.currentIndex,
    required this.onTabSelected,
  });

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // Barra de cima
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Título
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Botão de Logout
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () => _logout(context),
                ),
              ],
            ),
          ),
          Expanded(child: body),
        ],
      ),

      // Barra de baixo
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.fitness_center,
                  color: currentIndex == 0 ? Colors.white : const Color.fromARGB(255, 187, 187, 187)),
              onPressed: () => onTabSelected(0),
            ),
            IconButton(
              icon: Icon(Icons.apps,
                  color: currentIndex == 1 ? Colors.white : const Color.fromARGB(255, 187, 187, 187)),
              onPressed: () => onTabSelected(1),
            ),
            IconButton(
              icon: Icon(Icons.chat_bubble,
                  color: currentIndex == 2 ? Colors.white : const Color.fromARGB(255, 187, 187, 187)),
              onPressed: () => onTabSelected(2),
            ),
          ],
        ),
      ),
    );
  }
}
