import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SecurityService {
  static const MethodChannel _channel = MethodChannel('app.security.channel');

  /// Activa o desactiva la protección contra capturas de pantalla de forma nativa.
  Future<void> preventScreenshots(bool prevent) async {
    if (kIsWeb) return;
    
    if (Platform.isAndroid) {
      try {
        await _channel.invokeMethod('preventScreenshots', {'prevent': prevent});
      } on PlatformException catch (e) {
        debugPrint("Error configuring screen protection: '${e.message}'.");
      }
    }
    // En iOS se requiere una implementación más compleja con vistas superpuestas,
    // pero para el objetivo actual de eliminar el warning de KGP en Android,
    // con esto es suficiente.
  }
}
