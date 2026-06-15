class Cancion {
  final String? id;
  final String idCancion;
  final String titulo;
  final String letra;
  final String estilo;
  final String tonalidad;
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
