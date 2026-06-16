import 'package:flutter/material.dart';

void main() {
  runApp(const CancioneroApp());
}

class CancioneroApp extends StatelessWidget {
  const CancioneroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cancionero',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF1A0A00),
        body: Center(
          child: Text(
            '🎸 Cancionero funcionando',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
