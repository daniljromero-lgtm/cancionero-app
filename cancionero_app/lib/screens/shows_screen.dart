import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowsScreen extends StatelessWidget {
  const ShowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0A00),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D0A00),
        iconTheme: const IconThemeData(color: Color(0xFFE8C87A)),
        title: Text('Shows en vivo',
            style: GoogleFonts.playfairDisplay(
                color: const Color(0xFFE8C87A),
                fontWeight: FontWeight.bold)),
      ),
      body: const Center(
        child: Text('Próximamente... 🎤',
            style: TextStyle(color: Colors.white54, fontSize: 18)),
      ),
    );
  }
}
