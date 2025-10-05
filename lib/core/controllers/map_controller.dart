import 'package:geolocator/geolocator.dart';
import 'package:live_frontend/core/repositories/map_repository.dart';

class MapController {
  final MapRepository _repository = MapRepository();

  // 현재 내 위치를 조회 (위도, 경도 기반)
  Future<Position?> fetchLatLng() async {
    try {
      return await _repository.fetchLatLng();
    } catch (e) {
      return null;
    }
  }
}