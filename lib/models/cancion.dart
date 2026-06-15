// lib/models/cancion.dart
// Define la estructura de un documento en la colección 'Canciones' de Firestore

class Cancion {
  final String? id;          // ID del documento en Firestore (autogenerado)
  final String idCancion;    // Campo id_cancion
  final String titulo;
  final String letra;
  final String estilo;       // chacarera, zamba, escondido, gato, chamamé
  final String tonalidad;    // Cifrado americano (ej: Am, G, C#m...)
  final int bpm;

  Cancion({
    this.id,
    required this.idCancion,
    required this.titulo,
    required this.letra,
    required this.estilo,
    required this.tonalidad,
    required this.bpm,
  });

  // Convierte un documento de Firestore en un objeto Cancion
  factory Cancion.fromFirestore(Map<String, dynamic> data, String docId) {
    return Cancion(
      id: docId,
      idCancion: data['id_cancion'] ?? '',
      titulo: data['titulo'] ?? '',
      letra: data['letra'] ?? '',
      estilo: data['estilo'] ?? '',
      tonalidad: data['tonalidad'] ?? '',
      bpm: (data['bpm'] ?? 0).toInt(),
    );
  }

  // Convierte un objeto Cancion en un Map para guardar en Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id_cancion': idCancion,
      'titulo': titulo,
      'letra': letra,
      'estilo': estilo,
      'tonalidad': tonalidad,
      'bpm': bpm,
    };
  }
}
