import 'package:geolocator/geolocator.dart';

class MapRepository {
  Future<Position> fetchLatLng() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    return position;
  }
}