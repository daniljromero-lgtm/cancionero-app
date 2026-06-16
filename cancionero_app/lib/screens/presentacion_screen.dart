import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cancion.dart';
import '../models/repertorio.dart';
import '../services/firestore_service.dart';

class PresentacionScreen extends StatefulWidget {
  final Repertorio repertorio;
  const PresentacionScreen({super.key, required this.repertorio});

  @override
  State<PresentacionScreen> createState() =>
      _PresentacionScreenState();
}

class _PresentacionScreenState
    extends State<PresentacionScreen> {
  final FirestoreService _service = FirestoreService();
  List<Cancion> _canciones = [];
  int _indiceActual = 0;
  bool _cargando = true;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]);
    _cargarCanciones();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _cargarCanciones() async {
    final canciones = await _service
        .cancionesPorIds(widget.repertorio.canciones);
    setState(() {
      _canciones = canciones;
      _cargando = false;
    });
  }

  void _anterior() {
    if (_indiceActual > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _siguiente() {
    if (_indiceActual < _canciones.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A0A00),
        body: Center(
            child: CircularProgressIndicator(
                color: Color(0xFFE8C87A))),
      );
    }

    if (_canciones.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFF1A0A00),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2D0A00),
          iconTheme:
              const IconThemeData(color: Color(0xFFE8C87A)),
          title: Text(widget.repertorio.nombre,
              style: GoogleFonts.playfairDisplay(
                  color: const Color(0xFFE8C87A))),
        ),
        body: const Center(
            child: Text('No hay canciones en este show.',
                style: TextStyle(color: Colors.white54))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D0500),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────
            Container(
              color: const Color(0xFF1A0A00),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: Color(0xFFE8C87A)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      children: [
                        Text(widget.repertorio.nombre,
                            style: GoogleFonts.lato(
                                color: Colors.white38,
                                fontSize: 12)),
                        Text(
                          _canciones[_indiceActual].titulo,
                          style: GoogleFonts.playfairDisplay(
                              color: const Color(0xFFE8C87A),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  // Contador
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A1A00),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_indiceActual + 1}/${_canciones.length}',
                      style: GoogleFonts.lato(
                          color: const Color(0xFFE8C87A),
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // ── Contenido scrolleable (PageView vertical) ─────────
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: (index) =>
                    setState(() => _indiceActual = index),
                itemCount: _canciones.length,
                itemBuilder: (context, index) {
                  final cancion = _canciones[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // Chips metadata
                        Wrap(
                          spacing: 8,
                          children: [
                            _chip('🎸 ${cancion.tonalidad}'),
                            _chip('⏱️ ${cancion.bpm} BPM'),
                            _chip(cancion.estilo),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Letra
                        Text(
                          cancion.letra.isNotEmpty
                              ? cancion.letra
                              : '(Sin letra cargada)',
                          style: GoogleFonts.lato(
                            color: cancion.letra.isNotEmpty
                                ? Colors.white
                                : Colors.white38,
                            fontSize: 18,
                            height: 2.0,
                          ),
                        ),

                        // Espacio al final para indicar que hay más
                        if (index < _canciones.length - 1) ...[
                          const SizedBox(height: 40),
                          Center(
                            child: Column(
                              children: [
                                const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFFE8C87A),
                                    size: 32),
                                Text(
                                  'Siguiente: ${_canciones[index + 1].titulo}',
                                  style: GoogleFonts.lato(
                                      color: const Color(
                                          0xFFE8C87A),
                                      fontSize: 13),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ] else ...[
                          const SizedBox(height: 40),
                          Center(
                            child: Text('🎉 Fin del show',
                                style: GoogleFonts.lato(
                                    color: Colors.white38,
                                    fontSize: 14)),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),

            // ── Controles ─────────────────────────────────────────
            Container(
              color: const Color(0xFF1A0A00),
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed:
                        _indiceActual > 0 ? _anterior : null,
                    icon: Icon(
                      Icons.skip_previous_rounded,
                      color: _indiceActual > 0
                          ? const Color(0xFFE8C87A)
                          : Colors.white24,
                      size: 40,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _canciones[_indiceActual].titulo,
                        style: GoogleFonts.lato(
                            color: Colors.white70,
                            fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: _indiceActual 
                            _canciones.length - 1
                        ? _siguiente
                        : null,
                    icon: Icon(
                      Icons.skip_next_rounded,
                      color: _indiceActual 
                              _canciones.length - 1
                          ? const Color(0xFFE8C87A)
                          : Colors.white24,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String texto) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF4A1A00),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(texto,
          style: GoogleFonts.lato(
              color: const Color(0xFFE8C87A), fontSize: 12)),
    );
  }
}
