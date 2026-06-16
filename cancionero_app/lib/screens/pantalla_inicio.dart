import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'shows_screen.dart';

class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0A00),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // ── Logo y título ──────────────────────────────────────
              Center(
                child: Text('🎸',
                    style: const TextStyle(fontSize: 72)),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Cancionero',
                  style: GoogleFonts.playfairDisplay(
                    color: const Color(0xFFE8C87A),
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Tu compañero en el escenario',
                  style: GoogleFonts.lato(
                    color: Colors.white38,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // ── Botón Cancionero ───────────────────────────────────
              _MenuButton(
                emoji: '🎵',
                titulo: 'Cancionero',
                subtitulo: 'Todas tus canciones por género',
                color: const Color(0xFF4A1A00),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen())),
              ),

              const SizedBox(height: 20),

              // ── Botón Shows ────────────────────────────────────────
              _MenuButton(
                emoji: '🎤',
                titulo: 'Shows en vivo',
                subtitulo: 'Armá el repertorio para tu próximo show',
                color: const Color(0xFF1A0A2E),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ShowsScreen())),
              ),

              const Spacer(),

              Center(
                child: Text(
                  'Folklore Argentino 🌿',
                  style: GoogleFonts.lato(
                      color: Colors.white24, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final String emoji;
  final String titulo;
  final String subtitulo;
  final Color color;
  final VoidCallback onTap;

  const _MenuButton({
    required this.emoji,
    required this.titulo,
    required this.subtitulo,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8C87A30)),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: GoogleFonts.playfairDisplay(
                        color: const Color(0xFFE8C87A),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 4),
                  Text(subtitulo,
                      style: GoogleFonts.lato(
                          color: Colors.white54, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                color: Color(0xFFE8C87A), size: 28),
          ],
        ),
      ),
    );
  }
}
