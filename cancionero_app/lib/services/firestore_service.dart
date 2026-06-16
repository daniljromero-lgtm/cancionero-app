// lib/services/firestore_service.dart
// Centraliza todas las operaciones con Firestore

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cancion.dart';
import '../models/repertorio.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── REFERENCIAS A COLECCIONES ────────────────────────────────────────────

  CollectionReference get _canciones => _db.collection('Canciones');
  CollectionReference get _repertorios => _db.collection('Repertorios');

  // ─── CANCIONES ────────────────────────────────────────────────────────────

  /// Devuelve un stream de todas las canciones de un estilo, ordenadas A→Z
  Stream<List<Cancion>> cancionesPorEstilo(String estilo) {
    return _canciones
        .where('estilo', isEqualTo: estilo)
        .orderBy('titulo')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Cancion.fromFirestore(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ))
            .toList());
  }

  /// Devuelve un stream de TODAS las canciones ordenadas A→Z
  Stream<List<Cancion>> todasLasCanciones() {
    return _canciones
        .orderBy('titulo')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Cancion.fromFirestore(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ))
            .toList());
  }

  /// Agrega una canción nueva a Firestore
  Future<void> agregarCancion(Cancion cancion) async {
    await _canciones.add(cancion.toFirestore());
  }

  /// Elimina una canción por su ID de documento
  Future<void> eliminarCancion(String docId) async {
    await _canciones.doc(docId).delete();
  }

  /// Actualiza una canción existente
  Future<void> actualizarCancion(String docId, Cancion cancion) async {
    await _canciones.doc(docId).update(cancion.toFirestore());
  }

  // ─── REPERTORIOS ──────────────────────────────────────────────────────────

  /// Devuelve un stream de todos los repertorios
  Stream<List<Repertorio>> todosLosRepertorios() {
    return _repertorios
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Repertorio.fromFirestore(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ))
            .toList());
  }

  /// Agrega un repertorio nuevo
  Future<void> agregarRepertorio(Repertorio repertorio) async {
    await _repertorios.add(repertorio.toFirestore());
  }

  /// Elimina un repertorio por su ID de documento
  Future<void> eliminarRepertorio(String docId) async {
    await _repertorios.doc(docId).delete();
  }
  
// ─── REPERTORIOS CRUD ─────────────────────────────────────────────────────

  Stream<List<Repertorio>> todosLosRepertorios() {
    return _repertorios
        .orderBy('nombre')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Repertorio.fromFirestore(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ))
            .toList());
  }

  Future<void> agregarRepertorio(Repertorio repertorio) async {
    await _repertorios.add(repertorio.toFirestore());
  }

  Future<void> eliminarRepertorio(String docId) async {
    await _repertorios.doc(docId).delete();
  }

  Future<void> actualizarRepertorio(String docId, Repertorio repertorio) async {
    await _repertorios.doc(docId).update(repertorio.toFirestore());
  }

  Future<List<Cancion>> cancionesPorIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final List<Cancion> resultado = [];
    for (final id in ids) {
      final doc = await _canciones.doc(id).get();
      if (doc.exists) {
        resultado.add(Cancion.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id));
      }
    }
    return resultado;
  }
