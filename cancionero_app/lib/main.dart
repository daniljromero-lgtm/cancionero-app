import 'screens/pantalla_inicio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Si Firebase falla, la app igual arranca
    debugPrint('Firebase error: $e');
  }
  
  runApp(const CancioneroApp());
}

class CancioneroApp extends StatelessWidget {
  const CancioneroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cancionero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B1A1A),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const PantallaInicio(),
    );
  }
}
