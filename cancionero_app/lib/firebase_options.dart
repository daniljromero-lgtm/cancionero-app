// IMPORTANTE: Reemplazá este archivo con el tuyo generado por FlutterFire CLI
// o copiá los valores desde Firebase Console > Configuración del proyecto
//
// Para generarlo automáticamente:
//   dart pub global activate flutterfire_cli
//   flutterfire configure
//
// Por ahora usamos valores de ejemplo que HAY QUE reemplazar:

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('Plataforma no soportada');
    }
  }

  // ⚠️ REEMPLAZÁ ESTOS VALORES con los de tu proyecto Firebase
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCDW6qQeYPSBvKXyVil0Y4TFjBETLszJao',
    appId: '1:522780296914:android:d316e031869cb6ddebcf0b',
    messagingSenderId: '522780296914',
    projectId: 'cancionerointeractivo',
    storageBucket: 'cancionerointeractivo.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCDW6qQeYPSBvKXyVil0Y4TFjBETLszJao',
    appId: '1:522780296914:web:0b99e4fa3ec9c780ebcf0b',
    messagingSenderId: '522780296914',
    projectId: 'cancionerointeractivo',
    storageBucket: 'cancionerointeractivo.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCDW6qQeYPSBvKXyVil0Y4TFjBETLszJao',
    appId: '1:522780296914:android:d316e031869cb6ddebcf0b',
    messagingSenderId: '522780296914',
    projectId: 'cancionerointeractivo',
    storageBucket: 'cancionerointeractivo.firebasestorage.app',
    iosBundleId: 'com.cancionero.app',
  );
}

