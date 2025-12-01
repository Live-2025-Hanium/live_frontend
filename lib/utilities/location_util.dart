import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

Future<Position?> getCurrentLocation() async {
  try {
    // Check if location services are enabled on the device
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled.');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('Location permission denied by user.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint(
        'Location permission is denied forever. User must enable it from settings.',
      );
      return null;
    }

    // Attempt to get current position with a timeout
    final locationSettings = LocationSettings(accuracy: LocationAccuracy.high);
    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    ).timeout(const Duration(seconds: 10));
  } catch (e, st) {
    debugPrint('Failed to get current location: $e\n$st');
    return null;
  }
}
