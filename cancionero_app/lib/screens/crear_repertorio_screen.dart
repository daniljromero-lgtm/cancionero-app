import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cancion.dart';
import '../models/repertorio.dart';
import '../services/firestore_service.dart';

class CrearRepertorioScreen extends StatefulWidget {
  const CrearRepertorioScreen({super.key});

  @override
  State<CrearRepertorioScreen> createState() =>
      _CrearRepertorioScreenState();
}

class _CrearRepertorioScreenState
    extends State<CrearRepertorioScreen> {
  final _service = FirestoreService();
  final _nombreCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();
  final _lugarCtrl = TextEditingController();

  // Canciones seleccionadas (en orden)
  final List<Cancion> _seleccionadas = [];
  bool _guardando = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _fechaCtrl.dispose();
    _lugarCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_nombreCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Poné un nombre al show')));
      return;
    }
    if (_seleccionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agregá al menos una canción')));
      return;
    }

    setState(() => _guardando = true);
    try {
      final rep = Repertorio(
        nombre: _nombreCtrl.text.trim(),
        fecha: _fechaCtrl.text.trim(),
        lugar: _lugarCtrl.text.trim(),
        canciones: _seleccionadas.map((c) => c.id!).toList(),
      );
      await _service.agregarRepertorio(rep);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0A00),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D0A00),
        iconTheme: const IconThemeData(color: Color(0xFFE8C87A)),
        title: Text('Nuevo show',
            style: GoogleFonts.playfairDisplay(
                color: const Color(0xFFE8C87A),
                fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _guardando ? null : _guardar,
            child: Text('Guardar',
                style: GoogleFonts.lato(
                    color: const Color(0xFFE8C87A),
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Datos del show ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _campo(_nombreCtrl, 'Nombre del show *',
                    'ej: Peña de San Juan'),
                const SizedBox(height: 12),
                _campo(_fechaCtrl, 'Fecha', 'ej: 24/06/2025'),
                const SizedBox(height: 12),
                _campo(_lugarCtrl, 'Lugar', 'ej: Club Atlético'),
              ],
            ),
          ),

          // ── Lista seleccionada (reordenable) ─────────────────────
          if (_seleccionadas.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text('Canciones del show (${_seleccionadas.length})',
                      style: GoogleFonts.lato(
                          color: const Color(0xFFE8C87A),
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text('Arrastrá para reordenar',
                      style: GoogleFonts.lato(
                          color: Colors.white38, fontSize: 12)),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: ReorderableListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: _seleccionadas.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final item = _seleccionadas.removeAt(oldIndex);
                    _seleccionadas.insert(newIndex, item);
                  });
                },
                itemBuilder: (context, index) {
                  final c = _seleccionadas[index];
                  return ListTile(
                    key: ValueKey(c.id),
                    dense: true,
                    leading: Text('${index + 1}.',
                        style: const TextStyle(
                            color: Color(0xFFE8C87A))),
                    title: Text(c.titulo,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14)),
                    subtitle: Text(
                        '${c.estilo} • ${c.tonalidad}',
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 12)),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          color: Colors.redAccent, size: 20),
                      onPressed: () => setState(
                          () => _seleccionadas.removeAt(index)),
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Colors.white12),
          ],

          // ── Todas las canciones para agregar ─────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            child: Text('Tocá una canción para agregarla al show:',
                style: GoogleFonts.lato(
                    color: Colors.white54, fontSize: 13)),
          ),
          Expanded(
            child: StreamBuilder<List<Cancion>>(
              stream: _service.todasLasCanciones(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFFE8C87A)));
                }
                final todas = snapshot.data!;
                return ListView.builder(
                  itemCount: todas.length,
                  itemBuilder: (context, index) {
                    final c = todas[index];
                    final yaAgregada = _seleccionadas
                        .any((s) => s.id == c.id);
                    return ListTile(
                      dense: true,
                      leading: Icon(
                        yaAgregada
                            ? Icons.check_circle
                            : Icons.add_circle_outline,
                        color: yaAgregada
                            ? const Color(0xFFE8C87A)
                            : Colors.white38,
                      ),
                      title: Text(c.titulo,
                          style: TextStyle(
                              color: yaAgregada
                                  ? const Color(0xFFE8C87A)
                                  : Colors.white,
                              fontSize: 14)),
                      subtitle: Text(
                          '${c.estilo} • ${c.tonalidad} • ${c.bpm} BPM',
                          style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 12)),
                      onTap: () {
                        setState(() {
                          if (yaAgregada) {
                            _seleccionadas
                                .removeWhere((s) => s.id == c.id);
                          } else {
                            _seleccionadas.add(c);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _campo(TextEditingController ctrl, String label,
      String hint) {
    return TextFormField(
      controller: ctrl,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle:
            const TextStyle(color: Color(0xFFE8C87A)),
        hintStyle: const TextStyle(color: Colors.white30),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color(0xFFE8C87A), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: const Color(0xFF2D1A00),
      ),
    );
  }
}
