// lib/screens/detalle_cancion_screen.dart
// Muestra la letra completa de una canción

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cancion.dart';

class DetalleCancionScreen extends StatelessWidget {
  final Cancion cancion;

  const DetalleCancionScreen({super.key, required this.cancion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0A00),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D0A00),
        iconTheme: const IconThemeData(color: Color(0xFFE8C87A)),
        title: Text(
          cancion.titulo,
          style: GoogleFonts.playfairDisplay(
            color: const Color(0xFFE8C87A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Metadata ──────────────────────────────────────────────────
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                _Chip(
                  icon: '🎵',
                  label: cancion.estilo[0].toUpperCase() +
                      cancion.estilo.substring(1),
                ),
                _Chip(icon: '🎸', label: 'Tonalidad: ${cancion.tonalidad}'),
                _Chip(icon: '⏱️', label: '${cancion.bpm} BPM'),
              ],
            ),
            const SizedBox(height: 28),

            // ── Letra ─────────────────────────────────────────────────────
            Text(
              'Letra',
              style: GoogleFonts.playfairDisplay(
                color: const Color(0xFFE8C87A),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2D1A00),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: Text(
                cancion.letra.isNotEmpty
                    ? cancion.letra
                    : '(Sin letra cargada)',
                style: GoogleFonts.lato(
                  color: cancion.letra.isNotEmpty
                      ? Colors.white.withOpacity(0.87)
                      : Colors.white38,
                  fontSize: 16,
                  height: 1.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String icon;
  final String label;

  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF4A1A00),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8C87A30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.lato(
              color: const Color(0xFFE8C87A),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
