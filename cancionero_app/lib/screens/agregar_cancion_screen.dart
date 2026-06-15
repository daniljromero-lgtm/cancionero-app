// lib/screens/agregar_cancion_screen.dart
// Formulario para cargar una canción nueva en Firestore

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/cancion.dart';
import '../services/firestore_service.dart';

const List<String> kEstilos = [
  'chacarera',
  'zamba',
  'escondido',
  'gato',
  'chamamé',
];

// Tonalidades más usadas en folklore argentino (cifrado americano)
const List<String> kTonalidades = [
  'A', 'Am', 'Bb', 'Bbm', 'B', 'Bm',
  'C', 'Cm', 'C#', 'C#m',
  'D', 'Dm', 'Eb', 'Ebm', 'E', 'Em',
  'F', 'Fm', 'F#', 'F#m',
  'G', 'Gm', 'G#', 'G#m',
];

class AgregarCancionScreen extends StatefulWidget {
  const AgregarCancionScreen({super.key});

  @override
  State<AgregarCancionScreen> createState() => _AgregarCancionScreenState();
}

class _AgregarCancionScreenState extends State<AgregarCancionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = FirestoreService();

  // Controladores de texto
  final _tituloCtrl    = TextEditingController();
  final _letraCtrl     = TextEditingController();
  final _bpmCtrl       = TextEditingController(text: '80');
  final _idCancionCtrl = TextEditingController();

  String _estiloSeleccionado    = kEstilos.first;
  String _tonalidadSeleccionada = 'A';
  bool _guardando = false;

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _letraCtrl.dispose();
    _bpmCtrl.dispose();
    _idCancionCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    try {
      final nuevaCancion = Cancion(
        idCancion:  _idCancionCtrl.text.trim(),
        titulo:     _tituloCtrl.text.trim(),
        letra:      _letraCtrl.text.trim(),
        estilo:     _estiloSeleccionado,
        tonalidad:  _tonalidadSeleccionada,
        bpm:        int.parse(_bpmCtrl.text.trim()),
      );

      await _service.agregarCancion(nuevaCancion);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ "${nuevaCancion.titulo}" guardada'),
            backgroundColor: Colors.green.shade800,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  // ─── UI helpers ────────────────────────────────────────────────────────────

  InputDecoration _inputDeco(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Color(0xFFE8C87A)),
      hintStyle: const TextStyle(color: Colors.white30),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFE8C87A), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: const Color(0xFF2D1A00),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0A00),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D0A00),
        iconTheme: const IconThemeData(color: Color(0xFFE8C87A)),
        title: Text(
          'Nueva canción',
          style: GoogleFonts.playfairDisplay(
            color: const Color(0xFFE8C87A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── ID de canción (opcional, identificador propio) ──
              TextFormField(
                controller: _idCancionCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDeco('ID de canción (opcional)',
                    hint: 'ej: CHA001'),
              ),
              const SizedBox(height: 16),

              // ── Título ──
              TextFormField(
                controller: _tituloCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDeco('Título *'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'El título es obligatorio' : null,
              ),
              const SizedBox(height: 16),

              // ── Estilo (género) ──
              DropdownButtonFormField<String>(
                value: _estiloSeleccionado,
                dropdownColor: const Color(0xFF2D1A00),
                style: const TextStyle(color: Colors.white),
                decoration: _inputDeco('Estilo / Género *'),
                items: kEstilos
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e[0].toUpperCase() + e.substring(1),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _estiloSeleccionado = v!),
              ),
              const SizedBox(height: 16),

              // ── Tonalidad ──
              DropdownButtonFormField<String>(
                value: _tonalidadSeleccionada,
                dropdownColor: const Color(0xFF2D1A00),
                style: const TextStyle(color: Colors.white),
                decoration: _inputDeco('Tonalidad *'),
                items: kTonalidades
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t,
                              style: const TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _tonalidadSeleccionada = v!),
              ),
              const SizedBox(height: 16),

              // ── BPM ──
              TextFormField(
                controller: _bpmCtrl,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDeco('BPM *', hint: 'ej: 120'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Ingresá los BPM';
                  final bpm = int.tryParse(v);
                  if (bpm == null || bpm < 20 || bpm > 300) {
                    return 'BPM debe ser entre 20 y 300';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Letra ──
              TextFormField(
                controller: _letraCtrl,
                style: const TextStyle(color: Colors.white, height: 1.5),
                maxLines: 10,
                decoration: _inputDeco('Letra',
                    hint: 'Pegá aquí la letra de la canción...'),
              ),
              const SizedBox(height: 28),

              // ── Botón guardar ──
              ElevatedButton(
                onPressed: _guardando ? null : _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B1A1A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: _guardando
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        'Guardar canción',
                        style: GoogleFonts.lato(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
