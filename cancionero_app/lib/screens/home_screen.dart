// lib/screens/home_screen.dart
// Pantalla principal: tabs por género + lista de canciones A→Z

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/firestore_service.dart';
import '../models/cancion.dart';
import 'agregar_cancion_screen.dart';
import 'detalle_cancion_screen.dart';

// Los géneros disponibles en el cancionero
const List<Map<String, dynamic>> kGeneros = [
  {'nombre': 'Chacareras', 'estilo': 'chacarera', 'emoji': '🪘'},
  {'nombre': 'Zambas',     'estilo': 'zamba',      'emoji': '🌸'},
  {'nombre': 'Escondidos', 'estilo': 'escondido',  'emoji': '🎭'},
  {'nombre': 'Gatos',      'estilo': 'gato',       'emoji': '🐱'},
  {'nombre': 'Chamamés',   'estilo': 'chamamé',    'emoji': '🪗'},
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirestoreService _service = FirestoreService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: kGeneros.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFF1A0A00), // Marrón oscuro de madera
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D0A00),
        elevation: 0,
        title: Row(
          children: [
            const Text('🎸', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Text(
              'Cancionero',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE8C87A), // Dorado
              ),
            ),
          ],
        ),
        actions: [
          // Botón para agregar canción
          IconButton(
            icon: const Icon(Icons.add_circle_outline,
                color: Color(0xFFE8C87A), size: 28),
            tooltip: 'Agregar canción',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AgregarCancionScreen()),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: const Color(0xFFE8C87A),
          indicatorWeight: 3,
          labelColor: const Color(0xFFE8C87A),
          unselectedLabelColor: Colors.white54,
          labelStyle: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          tabs: kGeneros
              .map((g) => Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(g['emoji'], style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(g['nombre']),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: kGeneros
            .map((g) => _ListaCancionesTab(
                  estilo: g['estilo'],
                  service: _service,
                ))
            .toList(),
      ),
    );
  }
}

// ─── Widget: lista de canciones por género ────────────────────────────────────

class _ListaCancionesTab extends StatelessWidget {
  final String estilo;
  final FirestoreService service;

  const _ListaCancionesTab({required this.estilo, required this.service});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Cancion>>(
      stream: service.cancionesPorEstilo(estilo),
      builder: (context, snapshot) {
        // Estado: cargando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE8C87A)),
          );
        }

        // Estado: error
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        }

        final canciones = snapshot.data ?? [];

        // Estado: lista vacía
        if (canciones.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎵', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 16),
                Text(
                  'No hay canciones en este género todavía.',
                  style: GoogleFonts.lato(
                    color: Colors.white54,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tocá el + para agregar la primera.',
                  style: GoogleFonts.lato(
                    color: const Color(0xFFE8C87A),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }

        // Estado: lista con canciones
        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          itemCount: canciones.length,
          separatorBuilder: (_, __) =>
              const Divider(color: Colors.white12, height: 1),
          itemBuilder: (context, index) {
            final cancion = canciones[index];
            return _CancionTile(cancion: cancion, service: service);
          },
        );
      },
    );
  }
}

// ─── Widget: ítem de canción en la lista ─────────────────────────────────────

class _CancionTile extends StatelessWidget {
  final Cancion cancion;
  final FirestoreService service;

  const _CancionTile({required this.cancion, required this.service});

  void _confirmarEliminacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2D1A00),
        title: const Text('Eliminar canción',
            style: TextStyle(color: Color(0xFFE8C87A))),
        content: Text(
          '¿Eliminar "${cancion.titulo}"? Esta acción no se puede deshacer.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await service.eliminarCancion(cancion.id!);
            },
            child: const Text('Eliminar',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF4A1A00),
        child: Text(
          cancion.titulo.isNotEmpty
              ? cancion.titulo[0].toUpperCase()
              : '?',
          style: GoogleFonts.playfairDisplay(
            color: const Color(0xFFE8C87A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        cancion.titulo,
        style: GoogleFonts.lato(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${cancion.tonalidad}  •  ${cancion.bpm} BPM',
        style: GoogleFonts.lato(
          color: Colors.white54,
          fontSize: 13,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón eliminar
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: Colors.redAccent, size: 20),
            tooltip: 'Eliminar',
            onPressed: () => _confirmarEliminacion(context),
          ),
          const Icon(Icons.chevron_right, color: Colors.white30),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetalleCancionScreen(cancion: cancion),
        ),
      ),
    );
  }
}
