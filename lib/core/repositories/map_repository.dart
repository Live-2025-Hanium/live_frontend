import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:live_frontend/env.dart';

class MapRepository {
  Dio _dio;

  MapRepository(this._dio);

  Future<Position> fetchLatLng() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    return position;
  }

  Future<String?> fetchAddress(double lat, double lng) async {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://dapi.kakao.com/v2/local/geo/',
      headers: {'Authorization': 'KakaoAK ${Env.kakaoRestApiKey}'},
    ));

    final response = await _dio.get(
      'coord2address.json',
      queryParameters: {'x': lng, 'y': lat},
    );

    if (response.statusCode == 200) {
      final documents = response.data['documents'] as List;
      if (documents.isNotEmpty) {
        final address = documents[0]['address'];
        final road = documents[0]['road_address'];

        debugPrint("MapRepository: $road");

        return road != null
            ? road['address_name']
            : address['address_name'];
      }
    }

    return null;
  }
}