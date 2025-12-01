import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_frontend/providers/map_location_provider.dart';
import 'package:live_frontend/utilities/location_util.dart';

class MapLocationController extends StateNotifier<MapLocationState> {
  final Ref ref;

  MapLocationController(this.ref) : super(const MapLocationState());
  // {
  //   _initialize();
  // }

  // void _initialize() async {
  //   final pos = await getCurrentLocation();

  //   if (pos != null) {
  //     state = state.copyWith(
  //       currentLatitude: pos.latitude,
  //       currentLongitude: pos.longitude,
  //       centerLatitude: pos.latitude,
  //       centerLongitude: pos.longitude,
  //     );
  //   }
  // }

  void updateToCurrentLocation() async {
    final pos = await getCurrentLocation();

    if (pos != null) {
      state = state.copyWith(
        currentLatitude: pos.latitude,
        currentLongitude: pos.longitude,
      );
    }
  }

  void updateCenterLocation({
    required double latitude,
    required double longitude,
  }) {
    state = state.copyWith(
      centerLatitude: latitude,
      centerLongitude: longitude,
    );
  }

  void moveCenterToCurrentLocation() async {
    final pos = await getCurrentLocation();

    state = state.copyWith(
      centerLatitude: pos?.latitude,
      centerLongitude: pos?.longitude,
      currentLatitude: pos?.latitude,
      currentLongitude: pos?.longitude,
    );
  }
}
