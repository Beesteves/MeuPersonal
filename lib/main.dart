import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tcc/screens/cadastro_page.dart';
import 'package:tcc/screens/login_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
    primary: const Color(0xFFD32F2F),      // vermelho principal
    primaryContainer: const Color(0xFFB71C1C),
    secondary: const Color(0xFFEF5350),    // tom mais claro para accents
    onPrimary: Colors.white,
    surface: Colors.white,
    background: const Color.fromARGB(255, 244, 240, 240),
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
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.black87),
    headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black87),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFD32F2F)),
  ),
);
