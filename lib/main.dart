import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tcc/screens/cadastro_page.dart';
import 'package:tcc/screens/login_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Personal',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const LoginPage(),
      routes: {
        '/cadastroPersonal': (context) => const CadastroPage(tipo: 'personal'),
        '/login': (context) => const LoginPage(),
      }
    );
  }
}


/// Tema principal do app (inspire-se no visual do TrainingPeaks, porém em vermelho)
final ThemeData appTheme = ThemeData.light().copyWith(
  // Paleta principal (variações de vermelho)
  colorScheme: const ColorScheme.light().copyWith(
    primary: Color(0xFFD32F2F),      // vermelho principal
    primaryContainer: Color(0xFFB71C1C),
    secondary: Color(0xFFEF5350),    // tom mais claro para accents
    onPrimary: Colors.white,
    surface: Colors.white,
    background: Color(0xFFF7F7F8),
    onSurface: Colors.black87,
  ),

  // AppBar
  appBarTheme: const AppBarTheme(
    elevation: 2,
    backgroundColor: Color(0xFFD32F2F),
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),

  // Scaffold / Background
  scaffoldBackgroundColor: const Color(0xFFF7F7F8),

  // Floating action
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFD32F2F),
    foregroundColor: Colors.white,
    elevation: 6,
  ),

  // Elevated buttons (primary action)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFD32F2F),
      foregroundColor: Colors.white,
      elevation: 2,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),

  // Text buttons (secondary)
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFFD32F2F),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),

  // Outlined buttons
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFFD32F2F),
      side: const BorderSide(color: Color(0xFFD32F2F), width: 1.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),

  // Cards
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
  ),

  // Input decorations (TextField / TextFormField)
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.8),
    ),
    labelStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
    hintStyle: TextStyle(color: Colors.grey.shade500),
  ),

  // Bottom Navigation
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    elevation: 8,
    selectedItemColor: const Color(0xFFD32F2F),
    unselectedItemColor: Colors.grey.shade600,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),

  // ListTile
  listTileTheme: ListTileThemeData(
    tileColor: Colors.white,
    iconColor: const Color(0xFFD32F2F),
    textColor: Colors.black87,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),

  // Dialogs
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 6,
    titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
    contentTextStyle: const TextStyle(fontSize: 14, color: Colors.black54),
  ),

  // Chips
  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey.shade200,
    selectedColor: const Color(0xFFD32F2F).withOpacity(0.12),
    disabledColor: Colors.grey.shade100,
    labelStyle: const TextStyle(color: Colors.black87),
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),

  // Divider
  dividerTheme: DividerThemeData(color: Colors.grey.shade300, thickness: 1),

  // Typography (headline / body)
  textTheme: TextTheme(
    headlineLarge: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black87),
    headlineMedium: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87),
    titleLarge: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
    bodyLarge: const TextStyle(fontSize: 16, color: Colors.black87),
    bodyMedium: const TextStyle(fontSize: 14, color: Colors.black87),
    labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFD32F2F)),
  ),
);

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Meu App de Treino',
//       debugShowCheckedModeBanner: false,
//       theme: appTheme,
//       home: const DemoHomePage(),
//     );
//   }
// }

/// Pequena tela demo que demonstra os estilos aplicados.
/// Substitua `DemoHomePage` pelo seu `App()` quando estiver pronto.
// class DemoHomePage extends StatefulWidget {
//   const DemoHomePage({super.key});

//   @override
//   State<DemoHomePage> createState() => _DemoHomePageState();
// }

// class _DemoHomePageState extends State<DemoHomePage> {
//   int _index = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Meu App - Demo'),
//         actions: [
//           IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
//           IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         child: const Icon(Icons.add),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _index,
//         onTap: (i) => setState(() => _index = i),
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
//           BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Treinos'),
//           BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Text('Bem-vindo', style: Theme.of(context).textTheme.headlineLarge),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(14.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Treino da Semana', style: Theme.of(context).textTheme.titleLarge),
//                           const SizedBox(height: 6),
//                           Text('4 sessões • Foco em força', style: Theme.of(context).textTheme.bodyMedium),
//                           const SizedBox(height: 12),
//                           ElevatedButton(onPressed: () {}, child: const Text('Ver Treino')),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(14.0),
//                     child: Column(
//                       children: [
//                         Icon(Icons.trending_up, color: Theme.of(context).colorScheme.primary),
//                         const SizedBox(height: 6),
//                         Text('Progresso', style: Theme.of(context).textTheme.titleLarge),
//                         const SizedBox(height: 6),
//                         Text('Últimos 7 dias', style: Theme.of(context).textTheme.bodyMedium),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Text('Exercícios recentes', style: Theme.of(context).textTheme.headlineMedium),
//             const SizedBox(height: 8),
//             TextField(
//               decoration: const InputDecoration(
//                 labelText: 'Buscar exercício',
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Card(
//               child: ListTile(
//                 leading: CircleAvatar(backgroundColor: const Color(0xFFD32F2F), child: const Icon(Icons.fitness_center, color: Colors.white)),
//                 title: const Text('Agachamento'),
//                 subtitle: const Text('Força • 3x10'),
//                 trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
//               ),
//             ),
//             const SizedBox(height: 12),
//             Wrap(
//               spacing: 8,
//               children: [
//                 Chip(label: const Text('Força')),
//                 Chip(label: const Text('Cardio')),
//                 Chip(label: const Text('Mobilidade')),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
