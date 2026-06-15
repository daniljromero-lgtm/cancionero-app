// lib/models/repertorio.dart
// Define la estructura de un documento en la colección 'Repertorios' de Firestore

class Repertorio {
  final String? id;
  final String nombre;
  final String fecha;
  final String lugar;
  final List<String> canciones; // Lista de IDs de canciones

  Repertorio({
    this.id,
    required this.nombre,
    required this.fecha,
    required this.lugar,
    required this.canciones,
  });

  factory Repertorio.fromFirestore(Map<String, dynamic> data, String docId) {
    return Repertorio(
      id: docId,
      nombre: data['nombre'] ?? '',
      fecha: data['fecha'] ?? '',
      lugar: data['lugar'] ?? '',
      canciones: List<String>.from(data['canciones'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nombre': nombre,
      'fecha': fecha,
      'lugar': lugar,
      'canciones': canciones,
    };
  }
}
