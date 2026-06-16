import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/repertorio.dart';
import '../services/firestore_service.dart';
import 'crear_repertorio_screen.dart';
import 'presentacion_screen.dart';

class ShowsScreen extends StatelessWidget {
  const ShowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return Scaffold(
      backgroundColor: const Color(0xFF1A0A00),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D0A00),
        iconTheme: const IconThemeData(color: Color(0xFFE8C87A)),
        title: Text('Shows en vivo',
            style: GoogleFonts.playfairDisplay(
                color: const Color(0xFFE8C87A),
                fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline,
                color: Color(0xFFE8C87A), size: 28),
            tooltip: 'Nuevo show',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => const CrearRepertorioScreen())),
          ),
        ],
      ),
      body: StreamBuilder<List<Repertorio>>(
        stream: service.todosLosRepertorios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
                    color: Color(0xFFE8C87A)));
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.redAccent)));
          }

          final repertorios = snapshot.data ?? [];

          if (repertorios.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🎤',
                      style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 16),
                  Text('No tenés shows creados todavía.',
                      style: GoogleFonts.lato(
                          color: Colors.white54, fontSize: 15)),
                  const SizedBox(height: 8),
                  Text('Tocá el + para crear tu primer repertorio.',
                      style: GoogleFonts.lato(
                          color: const Color(0xFFE8C87A),
                          fontSize: 13)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: repertorios.length,
            separatorBuilder: (_, __) =>
                const Divider(color: Colors.white12, height: 1),
            itemBuilder: (context, index) {
              final rep = repertorios[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF1A0A2E),
                  child: Text('🎤',
                      style: const TextStyle(fontSize: 20)),
                ),
                title: Text(rep.nombre,
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                subtitle: Text(
                    '${rep.canciones.length} canciones  •  ${rep.fecha}',
                    style: GoogleFonts.lato(
                        color: Colors.white54, fontSize: 13)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Botón Play — modo presentación
                    IconButton(
                      icon: const Icon(Icons.play_circle_filled,
                          color: Color(0xFFE8C87A), size: 32),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PresentacionScreen(
                              repertorio: rep),
                        ),
                      ),
                    ),
                    // Botón eliminar
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.redAccent, size: 20),
                      onPressed: () => _confirmarEliminar(
                          context, service, rep),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmarEliminar(BuildContext context,
      FirestoreService service, Repertorio rep) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2D1A00),
        title: const Text('Eliminar show',
            style: TextStyle(color: Color(0xFFE8C87A))),
        content: Text('¿Eliminar "${rep.nombre}"?',
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await service.eliminarRepertorio(rep.id!);
            },
            child: const Text('Eliminar',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
