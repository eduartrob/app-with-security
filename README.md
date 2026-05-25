# Protection Information

Aplicación en Flutter desarrollada con un enfoque de seguridad y protección de información sensible, utilizando arquitectura MVVM.

## Arquitectura

El proyecto sigue el patrón **MVVM** (Model-View-ViewModel):
- **Data (DataSource):** Maneja la obtención de datos y validaciones (ej. credenciales de acceso estáticas para demostración).
- **ViewModel:** Gestiona la lógica de presentación y el estado de la aplicación utilizando `ChangeNotifier`.
- **View:** Interfaz de usuario construida con widgets de Flutter. Las vistas que muestran información sensible cuentan con protección contra capturas de pantalla.

## Seguridad

Se utiliza el paquete `screen_protector` para prevenir activamente que el sistema operativo permita tomar capturas de pantalla o grabar video en la vista de Login. Esta protección se habilita al entrar a la vista (`initState`) y se deshabilita al salir (`dispose`), garantizando que aplique únicamente a las áreas sensibles de la aplicación.

### Detección de Fake GPS
Para evitar que se suplante la ubicación del dispositivo mediante aplicaciones de terceros (Mock Locations o Fake GPS), la aplicación solicita permisos de ubicación tras un inicio de sesión exitoso y verifica si la ubicación proporcionada está siendo simulada a través del paquete `geolocator`. Si se detecta un uso indebido de Fake GPS, se restringe el acceso mediante una pantalla de bloqueo, permitiendo únicamente cerrar la aplicación.

## Previsualización

El proyecto integra `device_preview` para simular y previsualizar la interfaz de usuario en distintos dispositivos directamente desde la aplicación.

## Control de Versiones (SemVer)

El sistema de versionado en Flutter se maneja principalmente a través del archivo `pubspec.yaml`, siguiendo el estándar de Semantic Versioning (SemVer). 

El formato consta de dos partes clave:
1. **Nombre de la versión (versión pública):** `1.0.0` (Major.Minor.Patch)
2. **Código de compilación (número interno):** `+1`

**Versión Actual:** `1.1.0+2` (Changelog: Añadida verificación de Fake GPS tras el inicio de sesión).

> **Nota:** Cualquier actualización o parche futuro deberá seguir estas buenas prácticas incrementando la versión en el `pubspec.yaml`.
# app-with-security
