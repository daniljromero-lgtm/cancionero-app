# 🎸 Cancionero App — Guía de Configuración Paso a Paso

## ESTRUCTURA DE ARCHIVOS DEL PROYECTO

```
cancionero_app/
├── pubspec.yaml                          ← PASO 1: Reemplazá este archivo
├── lib/
│   ├── main.dart                         ← PASO 3: Reemplazá este archivo
│   ├── firebase_options.dart             ← PASO 2: Lo genera FlutterFire CLI (ver abajo)
│   ├── models/
│   │   ├── cancion.dart                  ← Copiá tal cual
│   │   └── repertorio.dart              ← Copiá tal cual
│   ├── services/
│   │   └── firestore_service.dart       ← Copiá tal cual
│   └── screens/
│       ├── home_screen.dart             ← Pantalla principal
│       ├── agregar_cancion_screen.dart  ← Formulario nueva canción
│       └── detalle_cancion_screen.dart  ← Vista de letra completa
└── android/
    └── app/
        └── build.gradle                 ← PASO 2b: verificar minSdk
```

---

## PASO 1 — Reemplazá el pubspec.yaml

Copiá el archivo `pubspec.yaml` que te di en la raíz de tu proyecto Flutter.
Luego ejecutá en la terminal:

```bash
flutter pub get
```

---

## PASO 2 — Conectar Firebase (FlutterFire CLI)

Este es el paso más importante. Genera el archivo `firebase_options.dart` automáticamente.

### 2a. Instalá la CLI de Firebase y FlutterFire:

```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

### 2b. Autenticá tu cuenta de Google:

```bash
firebase login
```

### 2c. Ejecutá la configuración desde la raíz de tu proyecto Flutter:

```bash
flutterfire configure
```

→ Seleccioná tu proyecto de Firebase cuando te lo pida.
→ Tildá Android (y iOS si lo necesitás).
→ Esto crea automáticamente `lib/firebase_options.dart` ✅

### 2d. Verificá el minSdk en android/app/build.gradle:

Abrí `android/app/build.gradle` y asegurate que diga:

```gradle
android {
    defaultConfig {
        minSdk 21       // ← Debe ser 21 o superior para Firebase
        ...
    }
}
```

---

## PASO 3 — Copiá los archivos de código

Copiá cada archivo en su ubicación exacta (respetando la estructura de carpetas):

| Archivo                            | Destino en tu proyecto                          |
|------------------------------------|-------------------------------------------------|
| main.dart                          | lib/main.dart                                   |
| models/cancion.dart                | lib/models/cancion.dart                         |
| models/repertorio.dart             | lib/models/repertorio.dart                      |
| services/firestore_service.dart    | lib/services/firestore_service.dart             |
| screens/home_screen.dart           | lib/screens/home_screen.dart                    |
| screens/agregar_cancion_screen.dart| lib/screens/agregar_cancion_screen.dart         |
| screens/detalle_cancion_screen.dart| lib/screens/detalle_cancion_screen.dart         |

---

## PASO 4 — Reglas de Firestore (modo prueba)

En la consola de Firebase → Firestore → Reglas, verificá que estén en modo prueba:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;  // Solo para desarrollo
    }
  }
}
```

⚠️ Antes de publicar la app, cambiá estas reglas a producción con autenticación.

---

## PASO 5 — Índices de Firestore (importante)

La consulta `where + orderBy` de Firestore requiere un índice compuesto.
La primera vez que abramos cada tab, Firestore puede pedir crearlo.

Podés crearlos manualmente en Firebase Console → Firestore → Índices:

| Colección | Campo 1    | Campo 2 | Orden     |
|-----------|------------|---------|-----------|
| Canciones | estilo ASC | titulo  | ASC       |

O simplemente ejecutá la app y hacé click en el link de error que aparece en la consola de Flutter (Firestore te da el link directo para crearlo con un click).

---

## PASO 6 — Compilar el APK

```bash
flutter build apk --release
```

El APK queda en: `build/app/outputs/flutter-apk/app-release.apk`

---

## ESTRUCTURA DE COLECCIONES EN FIRESTORE

### Colección: `Canciones`
```
Canciones/
└── {docId automático}/
    ├── id_cancion: "CHA001"
    ├── titulo:     "La Arunguita"
    ├── letra:      "Letra completa..."
    ├── estilo:     "chacarera"
    ├── tonalidad:  "Am"
    └── bpm:        120
```

### Colección: `Repertorios`
```
Repertorios/
└── {docId automático}/
    ├── nombre:    "Show Cosquín 2025"
    ├── fecha:     "2025-01-25"
    ├── lugar:     "Plaza Próspero Molina"
    └── canciones: ["docId1", "docId2", "docId3"]
```

---

## PRÓXIMOS PASOS (futuras entregas)

- [ ] Pantalla de gestión de Repertorios
- [ ] Modo presentación (letra a pantalla completa, scroll automático)
- [ ] Transposición de tonalidad en tiempo real
- [ ] Metrónomo integrado (usa el BPM de cada canción)
- [ ] Búsqueda global de canciones
- [ ] Modo oscuro / luz de escenario
