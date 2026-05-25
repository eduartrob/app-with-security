import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Requests location permissions if needed and checks if the location is mocked.
  /// Returns [true] if a Fake GPS is active, [false] otherwise.
  Future<bool> isFakeGpsActive() async {
    if (kIsWeb) return false;
    
    if (Platform.isAndroid || Platform.isIOS) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        try {
          Position position = await Geolocator.getCurrentPosition();
          return position.isMocked;
        } catch (e) {
          debugPrint('Error getting location: $e');
        }
      }
    }
    return false;
  }
}
