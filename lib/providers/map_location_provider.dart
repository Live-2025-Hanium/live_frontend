import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/core/controllers/map_location_controller.dart';

class MapLocationState {
  final double? currentLongitude;
  final double? currentLatitude;
  final double? centerLongitude;
  final double? centerLatitude;

  const MapLocationState({
    this.currentLongitude,
    this.currentLatitude,
    this.centerLongitude,
    this.centerLatitude,
  });

  MapLocationState copyWith({
    double? currentLongitude,
    double? currentLatitude,
    double? centerLongitude,
    double? centerLatitude,
  }) {
    return MapLocationState(
      currentLongitude: currentLongitude ?? this.currentLongitude,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      centerLongitude: centerLongitude ?? this.centerLongitude,
      centerLatitude: centerLatitude ?? this.centerLatitude,
    );
  }
}

final mapLocationProvider =
    StateNotifierProvider<MapLocationController, MapLocationState>(
      (ref) => MapLocationController(ref),
    );
