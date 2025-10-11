import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:live_frontend/core/repositories/map_repository.dart';
import 'package:live_frontend/providers/dio_provider.dart';

final mapControllerProvider =
    Provider((ref) => MapController(ref.read(dioProvider)));

class MapController {
  final Dio _dio;

  MapController(this._dio);

  // 현재 내 위치를 조회 (위도, 경도 기반)
  Future<Position?> fetchLatLng() async {
    try {
      return await MapRepository(_dio).fetchLatLng();
    } catch (e) {
      return null;
    }
  }

  // 현재 내 주소를 조회
  Future<String?> fetchAddress(double lat, double lng) async {
    try {
      return await MapRepository(_dio).fetchAddress(lat, lng);
    } catch (e) {
      return null;
    }
  }
}