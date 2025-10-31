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
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabSelected,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: 'Treinos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.apps), label: 'Ferramentas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble), label: 'Chat'),
        ],
      ),
    );
  }
}
